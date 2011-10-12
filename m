Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1JLHxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:53:21 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:40330 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab1JLHxT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:53:19 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: Re: [PATCH v2 2/6] MFD: twl6040: Cache the vibra control registers
Date: Wed, 12 Oct 2011 10:53:18 +0300
Message-ID: <2683250.RVKxy9YcCb@barack>
User-Agent: KMail/4.7.2 (Linux/3.0.4-gentoo; KDE/4.7.2; x86_64; ; )
In-Reply-To: <20111011144824.GE1098@sirena.org.uk>
References: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com> <1316760584-27426-3-git-send-email-peter.ujfalusi@ti.com> <20111011144824.GE1098@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 October 2011 15:48:24 Mark Brown wrote:
> It strikes me that it might be useful to just convert the driver to
> regmap and get cache for everything...

Good idea, I'll take a look at regmap
 
> Anyway, could you please restructure this series to minimize the
> dependency on the input subsystem?  Then we can get the rest of it
> applied.

Will send the v3 series soon.

--
Péter
