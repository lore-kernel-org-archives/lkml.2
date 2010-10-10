Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0JJP64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:58:56 -0400
Received: from smtp5.freeserve.com ([193.252.22.128]:3288 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab0JJP6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:58:54 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Oct 2010 11:58:54 EDT
X-ME-UUID: 20101010154853894.15CA01C00043@mwinf3417.me.freeserve.com
Date: Sun, 10 Oct 2010 16:48:18 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Lenovo S12 2.6.36-rc7 lockup
Message-ID: <20101010164818.6617102c@boulder.homenet>
In-Reply-To: <20101010135912.76eb61b7@boulder.homenet>
References: <20101010135912.76eb61b7@boulder.homenet>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010 13:59:12 +0100
Chris Vine <chris@cvine.freeserve.co.uk> wrote:
> Hi,
> 
> kernel 2.6.36-rc7 completely locks up my Lenovo S12 notebook on
> boot-up. It happens early enough in boot-up that nothing appears in
> any of the system log files.  The last message printed to the console
> is "Using IPI - No Shortcut mode".
> 
> The lock up does not occur with kernel 2.6.35.6.  I do not know in
> what version of 2.6.36-rc this first arose.
> 
> The kernel configuration is set out below.
> 
> Chris
[snip]

On testing now with the earlier 2.6.36-rc6, I see that it is not a
lock-up but a hang, in that it partly responds to the keyboard.  With
rc6 boot-up can proceed further than with rc7 (but very slowly) if
keyboard keys are more or less randomly pressed.  Boot up is never
completed though with rc6, even though it proceeds further.

Chris


