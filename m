Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0KXRHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:07:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57708
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab0KXRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:07:06 -0500
Date: Wed, 24 Nov 2010 09:07:30 -0800 (PST)
Message-Id: <20101124.090730.71102037.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: tomoya-linux@dsn.okisemi.com, wg@grandegger.com, w.sang@pengutronix.de,
        chripell@fsfe.org, 21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 8/17 v3] can: EG20T PCH: Change Copyright
 and module description
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CED14B0.9060208@pengutronix.de>
References: <4CED02C5.4080504@dsn.okisemi.com>
	<4CED14B0.9060208@pengutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 24 Nov 2010 14:35:44 +0100

> On 11/24/2010 01:19 PM, Tomoya MORINAGA wrote:
>> Currently, Copyright and module description are not formal.
> 
> As David pointed out in an older version of this series, this patch does
> more than the subject indicates. Please fix.

Many patches still have this problem.

I'm getting really upset about this.

Look, it's simple.  Make sure your patch commit message describes
everything the patch is doing.

And in many of the cases where the commit message is not accurate, it
is actually the cases that the changes not documented are totally
unrelated and need to be split up into a different change.

I strongly suspect that the pch_can folks became extremely frustrated
doing these patch split-ups.  They find them pointless and they feel
that we're putting an unnecessary burdon upon them, and are having
trouble understanding why we require this and why it's so incredibly
important.

So they worked on this task with the most minimum of effort and care,
which is extremely unfortunate.

We will continue to push back until they get things correct, so all
they do by being lazy and careless is make more work for everyone,
including themselves.
