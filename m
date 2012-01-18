Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2AROt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:49:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab2AROt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:49:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Date: Wed, 18 Jan 2012 14:49:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, greg@kroah.com,
        eric.piel@tremplin-utc.net, akpm@linux-foundation.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, "Nori, Sekhar" <nsekhar@ti.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com> <201201181403.47806.arnd@arndb.de> <20120118154344.4187f461@endymion.delvare>
In-Reply-To: <20120118154344.4187f461@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201181449.35904.arnd@arndb.de>
X-Provags-ID: V02:K0:qGyZO3w4q52kd76xs27thdKozqPSoWSYIvzKSL1SJJ6
 NIocw5weu68tJScDF8ZpoanZRh5/1PsNaeAVLiUlQmpjSM+6ht
 oi/RKeZ+YCWGOiNA6Bp1tDIo4WMD3dubHRFzdK5Zt0hIWx5Rkd
 1/H7uHXRoqRvoxbuAVca08Uv1H1iGzLFhcgh7UYce05YoGGklB
 IfOTD4Z8lokIC8lb0Mza+VHnc3GsarpCT9lekACtk9jHJkBG9J
 gd5kRAnYRRpq5gt30iFIbSRCThYuDf1cxndH/kJl447uSleNvc
 7po4oEOLgLBpV0BadogyGg6j9rWwLdhxStReuC/d0uua0CSTzi
 UronY+aJhDRSz3p/Nih4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 January 2012, Jean Delvare wrote:
> Hi Arnd and all,
> 
> The lis3lv02d driver was moved outside of drivers/hwmon to make it
> clear that we (hwmon/lm-sensors people) are not involved in maintaining
> this driver in any way. So please remove the lm-sensors list (and
> myself) from this discussion.

Ok, I see. What about the applesmc driver then? If we come up with
a solution that works for the other drivers, should the accelerometer
part of that be converted to use that interface?

	Arnd
