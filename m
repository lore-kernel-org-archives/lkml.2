Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab1BLPQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 10:16:38 -0500
Received: from smtp.nokia.com ([147.243.128.24]:42984 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1BLPQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 10:16:31 -0500
From: <peter.ujfalusi@nokia.com>
To: <dilinger@queued.net>, <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        <dmitry.torokhov@gmail.com>, <lrg@slimlogic.co.uk>, <perex@perex.cz>,
        <tiwai@suse.de>, <linux-input@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: RE: [PATCH 13/17] twl4030: mfd_cell is now implicitly available to
 drivers
Thread-Topic: [PATCH 13/17] twl4030: mfd_cell is now implicitly available to
 drivers
Thread-Index: AQHLylrFkzt81UQPCkGy+2mGg211rpP9+ohC
Date: Sat, 12 Feb 2011 15:15:02 +0000
Message-ID: <CF32F28EDF8D20468EEDCBE4975DA0274A4309@008-AM1MPN1-027.mgdnok.nokia.com>
References: <20110211181538.3230cb99@queued.net>
In-Reply-To: <20110211181538.3230cb99@queued.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Feb 2011 15:16:02.0809 (UTC) FILETIME=[C2F15690:01CBCAC7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ________________________________________
> From: ext Andres Salomon [dilinger@queued.net]
> Sent: Saturday, February 12, 2011 04:15
> To: Samuel Ortiz
> Cc: linux-kernel@vger.kernel.org; Mark Brown; Dmitry Torokhov; Ujfalusi Peter (Nokia-MS/Tampere); Liam Girdwood; Jaroslav Kysela; Takashi Iwai; linux-input@vger.kernel.org; alsa-devel@alsa-project.org
> Subject: [PATCH 13/17] twl4030: mfd_cell is now implicitly available to drivers
> 
> The cell's platform_data is now accessed with a helper function;
> change clients to use that, and remove the now-unused data_size.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---

Acked-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>