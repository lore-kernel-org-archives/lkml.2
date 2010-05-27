Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0E0MeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:34:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43694 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315Ab0E0MeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:34:21 -0400
X-Sasl-enc: ZYWUPpX9tUiw4C1sec0n2qXUEwnvZKRi/ONTeNXI9xLX 1274963660
Message-ID: <4BFE66CA.5070400@ladisch.de>
Date: Thu, 27 May 2010 14:34:18 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] No mixers on ATI RS780 Azalia
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr>	<s5hmxvmzwwd.wl%tiwai@suse.de>	<alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr>	<4BFD2901.20800@ladisch.de>	<alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr> <4BFE5AA1.7070103@ladisch.de>
In-Reply-To: <4BFE5AA1.7070103@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Please do not assume that the "HDMI" device is the right one, since you
> never got either one to work in Linux.

Hmm, that computer is separate from the actual LCD, which has an HDMI
input, so it's possible that the HDMI output would be correct.

In that case, it's likely that you've run into this bug:
https://bugs.freedesktop.org/show_bug.cgi?id=28030

You might try the patch mentioned there, or radeonhd, or fglrx.


HTH
Clemens
