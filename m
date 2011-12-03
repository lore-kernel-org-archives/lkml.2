Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1LCCw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 21:52:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41948 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755859Ab1LCCw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 21:52:26 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18Qf8c555EQ833OVOaFG1gdL3tYuO1g/UiqirNV1S
	26WtgVB2bdQxAI
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: Patch "rt2x00: handle spurious pci interrupts" has been added to the 3.1-stable tree
Date: Sat, 3 Dec 2011 03:52:05 +0100
User-Agent: KMail/1.13.7 (Linux/3.1-4.slh.1-aptosid-686; KDE/4.6.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, sgruszka@redhat.com, IvDoorn@gmail.com,
        linville@tuxdriver.com, stable@vger.kernel.org
References: <13228684632156@kroah.org>
In-Reply-To: <13228684632156@kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112030352.07030.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Saturday 03 December 2011, gregkh@suse.de wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     rt2x00: handle spurious pci interrupts
> 
> to the 3.1-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      rt2x00-handle-spurious-pci-interrupts.patch
> and it can be found in the queue-3.1 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> From 23085d5796561625db4143a671f1de081f66ef08 Mon Sep 17 00:00:00 2001
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> Date: Wed, 16 Nov 2011 13:58:42 +0100
> Subject: rt2x00: handle spurious pci interrupts
[...]

This patch has been reverted again, due to 
http://patchwork.ozlabs.org/patch/127153/
(this also applies to the 2.6.32 backport)

commit 6cccccafe9e8b88adb1800940ded6ad76c587e1b
Author: John W. Linville <linville@tuxdriver.com>
Date:   Tue Nov 22 16:36:35 2011 -0500

    Revert "rt2x00: handle spurious pci interrupts"
    
    This reverts commit 23085d5796561625db4143a671f1de081f66ef08.
    
    The original patch was a misguided attempt to improve performance on
    some hardware that is apparently prone to spurious interrupt generation.
    
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Regards
	Stefan Lippers-Hollmann
