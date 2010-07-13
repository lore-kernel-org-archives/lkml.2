Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab0GMDeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 23:34:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41448
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab0GMDeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 23:34:16 -0400
Date: Mon, 12 Jul 2010 20:34:31 -0700 (PDT)
Message-Id: <20100712.203431.216748245.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: error27@gmail.com, ericvh@gmail.com, adkulkar@umail.iu.edu,
        jvrao@us.ibm.com, linux-kernel@vger.kernel.org, tilman@code-monkey.de,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] 9p: strlen() doesn't count the terminator
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100712130458.bb8ae751.akpm@linux-foundation.org>
References: <20100710095154.GU19184@bicker>
	<20100712130458.bb8ae751.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 Jul 2010 13:04:58 -0700

> This bug doesn't strike me as serious enough to warrant backporting the fix
> into -stable.  What was your thinking there?

Meanwhile I'll queue this up to net-next-2.6, thanks.
