Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1ISJ42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:56:28 -0400
Received: from fsmail-out.f-secure.com ([193.110.108.171]:46777 "EHLO
	fsmail-out.f-secure.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab1ISJ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:56:26 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Sep 2011 05:56:26 EDT
Message-ID: <4E770FF5.8030207@f-secure.com>
Date: Mon, 19 Sep 2011 12:48:37 +0300
From: Tarkan Erimer <tarkan.erimer@f-secure.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [BUG] i915 crashes X Server Constantly on Linux-3.1-rc4 to .rc6
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-09-19_02:2011-09-19,2011-09-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having constant X crashes (Almost every 30 mins.) on Intel Graphics. 
Below is the error message after X crashes :

[  113.264775] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[  113.265289] [drm] Changing LVDS panel from (-hsync, -vsync) to 
(+hsync, -vsync)
[  114.141640] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 4955.770011] [drm:intel_disable_transcoder] *ERROR* failed to disable 
transcoder
[ 4955.777420] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 4955.938453] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 5255.360508] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 5255.527867] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 5744.182746] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 5744.349049] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 8536.532605] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 8536.533128] [drm] Changing LVDS panel from (+hsync, -vsync) to 
(-hsync, -vsync)
[ 8536.835206] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 8605.034788] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 8605.035302] [drm] Changing LVDS panel from (-hsync, -vsync) to 
(+hsync, -vsync)
[ 8606.110388] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 8869.586751] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 8869.587264] [drm] Changing LVDS panel from (+hsync, -vsync) to 
(-hsync, -vsync)
[ 8869.906322] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 8950.401958] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[ 8950.402472] [drm] Changing LVDS panel from (-hsync, -vsync) to 
(+hsync, -vsync)
[ 8951.066084] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH


Here is VGA info from lspci :

linux-ou2v:~ # lspci | grep -i vga
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core 
Processor Family Integrated Graphics Controller (rev 09)

And it's Xserver v1.11 and Intel Driver 2.16 with 
Kernel-3.1.0-rc6-2-desktop (opensuse). Also, this behavior happens from 
Linux-3.1-rc4 to rc6. At least these are the versions that I tried as 
3.1. Linux-3.0.x runs fine with same configuration.





-- 
Tarkan Erimer
IT Service Deployment / 3rd Level Support / Snr. Linux Engineer

