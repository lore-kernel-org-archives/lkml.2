Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1A0Ln6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:43:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55702 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab1A0Ln5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <20110127095441.GA1338@opensource.wolfsonmicro.com>
References: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com>
 <20110125150430.GF13051@sirena.org.uk> <AANLkTi=J6mC7yWL9DF91Tp4+67QpAVK8vTMVVmsfJNyw@mail.gmail.com>
 <20110127095441.GA1338@opensource.wolfsonmicro.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 27 Jan 2011 13:43:36 +0200
X-Google-Sender-Auth: pNYBSSSfHGdtL5JKa87oJEqcjPI
Message-ID: <AANLkTi=DWsZBtL9Wd1G_H4tC=iS9=05zdV0H00F_1Gcq@mail.gmail.com>
Subject: Re: [GIT PULL] TI WL 128x FM V4L2 driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: halli manjunatha <manjunatha_halli@ti.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 11:54 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> > So what happens when both
drivers are in the system?  It sounds like
> you've got two different drivers for the same hardware. There must be
> some redundancy there if nothing else.

Not really;

TI's 127x/128x devices are built of completely separate hardware
cores, with completely separate and independent drivers.

You can use one, a subset, or all of the cores (/drivers) together on
the same time.

The mainline wl12xx driver you refer to is a mac80211 SDIO/SPI WLAN
driver that has nothing to do with Manjunatha's FM driver.
