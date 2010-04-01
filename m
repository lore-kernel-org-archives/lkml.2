Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0DAH0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:26:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47701 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470Ab0DAH0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:26:16 -0400
X-Sasl-enc: U9JD+16cGy6JicosWRIOdKzLNgUex7Gey+DbUNspKi5i 1270106775
Message-ID: <4BB44A96.60709@ladisch.de>
Date: Thu, 01 Apr 2010 09:26:14 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] Regressions: MSI vs HDA-Intel
References: <64bb37e1003261025l14e2d82r64ba1e90d024bea6@mail.gmail.com>	<s5hfx3nm1lh.wl%tiwai@suse.de>	<64bb37e1003261059w3de67654m11ca17f1645f6c1@mail.gmail.com>	<s5hhbo26d68.wl%tiwai@suse.de>	<64bb37e1003261407y4d46c71cr3b39fc3058e0294a@mail.gmail.com>	<s5hd3yq6anu.wl%tiwai@suse.de> <64bb37e1003270234p3c7a10e2kd066d4459a60bb51@mail.gmail.com>
In-Reply-To: <64bb37e1003270234p3c7a10e2kd066d4459a60bb51@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> So all the messages about the failing codec and MSI belong to
> 0000:01:05.2, the HDMI output.

MSI seems to be broken on all(?) Radeon IGPs; see
<http://lkml.org/lkml/2010/3/30/290>.

Torsten, what is the output of "lspci -nn" on your first system?


Regards,
Clemens
