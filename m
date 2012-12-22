Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab2LVTft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:35:49 -0500
Received: from mcp.e404.de ([78.47.239.181]:51243 "EHLO mcp.e404.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab2LVTfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:35:47 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2012 14:35:47 EST
Message-ID: <50D60937.9050705@bernhard-seibold.de>
Date: Sat, 22 Dec 2012 20:25:43 +0100
From: Bernhard Seibold <mail@bernhard-seibold.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: daniel.vetter@ffwll.ch, chris@chris-wilson.co.uk,
        linux-kernel@vger.kernel.org
Subject: [regression v3.7] Xorg slow and studdering on Thinkpad X300 (GMA
 965)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I've noticed a regression using 3.7 on my Thinkpad X300.

In Cinnamon and in KDE with Desktop Effects, all graphics are slow and 
studdering. Moving a window results in about 5 frames per second.

glxgears achieves about 14 fps, versus ~60 in unaffected kernels.

X is from Debian unstable:

X.Org X Server 1.12.4
Release Date: 2012-08-27

(II) intel(0): Integrated Graphics Chipset: Intel(R) 965GM
(--) intel(0): Chipset: "965GM"


I did a bisect on this:

f047e395ddc9da6c307a10629a237502e627ed85 is the first bad commit.
a7b9761d0a2ded58170ffb4d423ff3d7228103f4 is "good".

If you need more information, please ask.

Regards,
Bernhard
