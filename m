Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab0GRX4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 19:56:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56446
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757645Ab0GRX4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 19:56:05 -0400
Date: Sun, 18 Jul 2010 16:56:20 -0700 (PDT)
Message-Id: <20100718.165620.133871819.davem@davemloft.net>
To: ydirson@free.fr
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] via82cxxx: fix typo for VT6415 PCIE PATA IDE Host
 Controller support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100718232838.GA3245@home.lan>
References: <1279494644-3762-1-git-send-email-ydirson@altern.org>
	<20100718232838.GA3245@home.lan>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Dirson <ydirson@free.fr>
Date: Mon, 19 Jul 2010 01:28:38 +0200

> On Mon, Jul 19, 2010 at 01:13:24AM +0200, Yann Dirson wrote:
>> Without this fix, init of the via82cxxx driver causes a oops with a
>> stack resembling the one below, and the boot blocks between init of
>> USB devices and launch of init (was easy to bisect by booting with
>> init=/bin/sh).
> 
> Looks like I was a bit too quick - this backtrace is not one of those
> I got without this fix (they never made it to the disk), but happens
> with the fix applied.

The fix is still correct, so I'll leave it in the tree.
