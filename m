Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab0LPR4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:56:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36386
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284Ab0LPR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:56:47 -0500
Date: Thu, 16 Dec 2010 09:57:16 -0800 (PST)
Message-Id: <20101216.095716.71123831.davem@davemloft.net>
To: bharrosh@panasas.com
Cc: npiggin@gmail.com, hooanon05@yahoo.co.jp, npiggin@kernel.dk,
        torvalds@linux-foundation.org, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D09E185.2040600@panasas.com>
References: <4D08BF5D.1060509@panasas.com>
	<20101215.100055.226772943.davem@davemloft.net>
	<4D09E185.2040600@panasas.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Date: Thu, 16 Dec 2010 11:53:09 +0200

> You miss understood me. I'm saying that we know the beggining of the
> string is aligned and Nick offered to pad the last long, so surly
> a shift by 2 (or 3) + the reduction of the 12 dec-and-test to 3
> should give you an optimization?

Indeed, we could do something interesting in the case where both
strings are tail padded like that.
