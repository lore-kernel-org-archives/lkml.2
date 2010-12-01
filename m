Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0LASDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:03:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34352
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720Ab0LASDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:03:04 -0500
Date: Wed, 01 Dec 2010 10:03:30 -0800 (PST)
Message-Id: <20101201.100330.226770021.davem@davemloft.net>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 21:15:58 +1100

> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working

Just want to say that I've been running this code for the past few days on
my 128 cpu box and it seems quite sturdy.

If there are any kinds of vfs benchmarks you want me to run on this
machine both with and without the scaling changes, just let me know.
