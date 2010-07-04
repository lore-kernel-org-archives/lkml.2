Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab0GDXT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 19:19:29 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:51380 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab0GDXT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 19:19:27 -0400
Date: Sun, 4 Jul 2010 19:19:26 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Radeon KMS doesn't work.
Message-ID: <20100704231926.GA1780@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20100703221056.GA17817@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100703221056.GA17817@animx.eu.org>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wakko Warner wrote:
> I have a Dell Inspiron 5100 with an ATI Radeon Mobility M7 (7500 R100
> PCI ID 1002:4c57 sub 1028:0149).
> 
> Immediately when radeon.ko is loaded, the screen goes blank (The backlight
> stays on).  I have fbcon compiled into the kernel (I also tried as module). 
> I am unable to get the screen to work again until I reboot.  The logs did
> not appear to have any errors after the module loaded.  The system was still
> responsive on the network.
> 
> I tried kernels 2.6.33 and 2.6.34.
> 
> I can provide kernel output if needed.

I need to add that if I use modeset=0, the screen does not blank.

Also 2.6.34 (with modeset=0) doesn't do 3D very well on this system.  Some
objects look ok, some are garbled, some do not appear at all.  The gears
from xscreensaver does not show up at all.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.

