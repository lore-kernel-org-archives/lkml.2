Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045Ab0E0Lme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:42:34 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60858 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759050Ab0E0Lm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:42:28 -0400
X-Sasl-enc: Tmf2lFRN06vdrVDaw25mODoJ72gL0Iul/dgZvqK4WQbl 1274960547
Message-ID: <4BFE5AA1.7070103@ladisch.de>
Date: Thu, 27 May 2010 13:42:25 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] No mixers on ATI RS780 Azalia
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr> <s5hmxvmzwwd.wl%tiwai@suse.de> <alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr> <4BFD2901.20800@ladisch.de> <alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Wednesday 2010-05-26 15:58, Clemens Ladisch wrote:
> > Try unmuting and raising both the Master and Beep controls.
> 
> I unmuted everything and bumped the sliders to 100% but that does not
> change a thing unfortunately; opening the right device (C1D3p) ...

Please do not assume that the "HDMI" device is the right one, since you
never got either one to work in Linux.  You did try playing through
the "SB" card, didn't you?

It is possible that an embedded device like this requires some custom
initialization.  Can you find out if the Windows driver is the standard
Microsoft driver or Samsung's?


Regards,
Clemens
