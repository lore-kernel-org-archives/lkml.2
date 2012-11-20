Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2KTCVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:21:50 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26017 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2KTCVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:21:46 -0500
X-AuditID: cbfee60d-b7fe86d000002849-0a-50aae9350950
Date: Tue, 20 Nov 2012 02:21:41 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 157/493] backlight: remove use of __devinit
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20121120021958336@jg1.han
Msgkey: 20121120021958336@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121120021958336@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7395749.680931353378098345.JavaMail.weblogic@epml04>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zI13Tl6sCDFZckLe4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqY8XrzKeaCW8IVH2efZWlgnCLcxcjJISSgJDHp5F5GEFtCwERi2/HH
	7BC2mMSFe+vZIGqWMUocXp4AU/Niw3ugOBdQfD6jxN/9F5hAEiwCqhJ3+k6zgNhsAuoSE343
	A9kcHMIC9hLrv7KChEUENCX2n7/LAtLLLLCAWWLp7CZmiAWyEvcmzwazeQUEJU7OfALWKyGg
	ILHyai5EWFHi1eRVbBA3SEjcub+fFcLmlZjR/pQFwpaTmPZ1DTOELS1xftYGRphfFn9/DBXn
	lzh2ewcTxHheiSf3g2HG7N78BWq8gMTUMwehWlUlbl7cABXnk1iz8C3UKkGJ09e6mWF6Gzb+
	BgcbM9CZU7ofQtlaEl9+7GND9RWI7ShxvrmDcQKj8iwkqVlI2mchaUdWs4CRZRWjaGpBckFx
	UnqqMXJcb2KEJEHeHYxzGywOMQpwMCrx8FomrwoQYk0sK67MPcQowcGsJMLbVA4U4k1JrKxK
	LcqPLyrNSS0+xDiRERiBE5mlRJPzgSk6ryTe0NjYxMzE1MTc0tTclBhhcyNTA2D6NTAkUVhJ
	nFexYnqAkEB6YklqdmpqQWoRzFFMHJxSDYyqr8oO9HRV62TOWGOiMyHhTIsdl7uPxULGKR+q
	xeYm76m9Fe73ymSKu3L8inozh8kpSo6OaYceJ2sE+2V+qTtYaxuv6tNztVfR/kr90uSq2IPe
	My4eWGj4JMnRyurEoS0Cy3/4C5sv38fr+qNkn1nfgvgVRk/+Pp1gMW/t8oM9fzpmWp0O5lJi
	Kc5INNRiLipOBAATBHuW9QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/tmbqmL1cFGFx6LW1xedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfSMLWOtDA0MjEyBqhIy
	Ml5vPsVccEu44uPssywNjFOEuxg5OYQElCQmndzLCGJLCJhIvNjwng3CFpO4cG89kM0FVDOf
	UeLv/gtMIAkWAVWJO32nWUBsNgF1iQm/m4FsDg5hAXuJ9V9ZQcIiApoS+8/fZQHpZRZYwCyx
	dHYTM8QyWYl7k2eD2bwCghInZz4B65UQUJBYeTUXIqwo8WryKqgbJCTu3N/PCmHzSsxof8oC
	YctJTPu6hhnClpY4P2sDI8zNi78/horzSxy7vYMJYjyvxJP7wTBjdm/+AjVeQGLqmYNQraoS
	Ny9ugIrzSaxZ+BZqlaDE6WvdzDC9DRt/s4PYzEBnTul+CGVrSXz5sY8N1VcgtqPE+eYOxgmM
	crOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXFSempxnrFibnFpXnpesn5uZsYwQnqGe8OxrkNFocY
	BTgYlXh4LZNXBQixJpYVV+YeYpTgYFYS4W0qBwrxpiRWVqUW5ccXleakFh9i9AHG30RmKdHk
	fGDyzCuJNzQ2NjEzMTU3sDCwNMchrCTOq1gxPUBIID2xJDU7NbUgtQhmHBMHp1QDY967l4H1
	DGvVW5a87+8SlTXIS3Vmmtpfwq9w5ZGB4MR87ai5OnWPLi/wibbbLLw26NW8KDvrqKlLlYTW
	ZttZyM9QUGWvDvCx+ClhYxjyeNFDnTMHV16V3SxbtZrJSWaC+5PF3i7fzeaXb9J9mPzwT7uO
	Uc2V6qnpLU+ypmRdNmcWsf8tIRWnxFKckWioxVxUnAgAzXsClH0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAK2LsHO019035

On Tuesday, November 20, 2012 3:22 AM, Bill Pemberton wrote
> 
> CONFIG_HOTPLUG is going away as an option so __devinit is no longer
> needed.
> 
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: device-drivers-devel@blackfin.uclinux.org
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/backlight/adp5520_bl.c         | 2 +-
>  drivers/video/backlight/adp8860_bl.c         | 6 +++---
>  drivers/video/backlight/adp8870_bl.c         | 6 +++---
>  drivers/video/backlight/ams369fg06.c         | 2 +-
>  drivers/video/backlight/apple_bl.c           | 2 +-
>  drivers/video/backlight/corgi_lcd.c          | 2 +-
>  drivers/video/backlight/ep93xx_bl.c          | 2 +-
>  drivers/video/backlight/hp680_bl.c           | 2 +-
>  drivers/video/backlight/ili9320.c            | 4 ++--
>  drivers/video/backlight/l4f00242t03.c        | 2 +-
>  drivers/video/backlight/lm3533_bl.c          | 4 ++--
>  drivers/video/backlight/lm3630_bl.c          | 4 ++--
>  drivers/video/backlight/lm3639_bl.c          | 4 ++--
>  drivers/video/backlight/lms283gf05.c         | 2 +-
>  drivers/video/backlight/ltv350qv.c           | 2 +-
>  drivers/video/backlight/max8925_bl.c         | 2 +-
>  drivers/video/backlight/pcf50633-backlight.c | 2 +-
>  drivers/video/backlight/platform_lcd.c       | 2 +-
>  drivers/video/backlight/s6e63m0.c            | 2 +-
>  drivers/video/backlight/tdo24m.c             | 2 +-
>  drivers/video/backlight/tosa_bl.c            | 2 +-
>  drivers/video/backlight/tosa_lcd.c           | 2 +-
>  drivers/video/backlight/vgg2432a4.c          | 2 +-
>  23 files changed, 31 insertions(+), 31 deletions(-)
> 

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
