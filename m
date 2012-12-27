Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2L0MnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 07:43:02 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:58025 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2L0MnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 07:43:01 -0500
Message-ID: <50DC422E.3070801@ahsoftware.de>
Date: Thu, 27 Dec 2012 13:42:22 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vincent Palatin <vpalatin@chromium.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
Subject: Re: [rtc-linux] [PATCH] rtc: recycle id when unloading a rtc driver
References: <1343951605-25722-1-git-send-email-vpalatin@chromium.org> <20121218164659.a3d3655a.akpm@linux-foundation.org> <50D16EA3.8040803@ahsoftware.de> <20121218234543.786a2211.akpm@linux-foundation.org> <50D1730D.7010108@ahsoftware.de> <20121219002722.87438a08.akpm@linux-foundation.org> <50D180E6.3010305@ahsoftware.de>
In-Reply-To: <50D180E6.3010305@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.12.2012 09:55, schrieb Alexander Holler:

> Unlikely, as I've worked hard to get one of the first drivers for
> pluggable RTCs into the kernel. ;)

BTW. maybe you could have a look at the patch for that:

https://lkml.org/lkml/2012/12/15/64

It should already be in your mailbox.

I had to move the driver (on maintainer request) from the iio subsystem 
to the rtc subsystem and even if Jonathon Cameron would feed the smal 
patch-series through iio into the kernel, an OK from one of the RTC 
maintainers (or you) is needed.

As the v5 of that patch suggests, it was already reviewed (by Lars-Peter 
Clausen) and should be in a good state.

Thanks,

Alexander

