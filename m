Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab1IIJl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:41:29 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:47950 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab1IIJl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:41:28 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tpa6130a2: Remove obsolete cleanup for clientdata
Date: Fri, 09 Sep 2011 12:41:24 +0300
Message-ID: <2947540.kyBvp2XKE8@barack>
User-Agent: KMail/4.7.1 (Linux/3.0.3-gentoo; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1315558020.2332.0.camel@phoenix>
References: <1315558020.2332.0.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 16:47:00 Axel Lin wrote:
> The i2c core will clear the clientdata pointer automatically,
> we don't have to set the `data' field to NULL in remove() or
> if probe() failed anymore.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
