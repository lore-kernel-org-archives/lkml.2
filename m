Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1ISLck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:32:40 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:51375 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab1ISLcj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:32:39 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: Re: [alsa-devel] [PATCH 00/17] ASoC: twl6040: Cleanups and fixes
Date: Mon, 19 Sep 2011 14:32:42 +0300
Message-ID: <73155881.Gph4EpKVic@barack>
User-Agent: KMail/4.7.1 (Linux/3.0.4-gentoo; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20110919101235.GA5467@sirena.org.uk>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com> <20110919101235.GA5467@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 September 2011 11:12:36 Mark Brown wrote:
> It'd be really good if you could manage to split this stuff up - this
> series is enormous and it's getting posted rather a lot, much of this
> stuff seems like it could be split out and posted separately.

It used to be 29 patches ;)
I would try to avoid resending this 17 patch in a smaller packs, unless it is 
really needed.
I did separated the two bigger change from this update series (Offset 
cancellation, vibra).
The changes within this series are quite straight forward,
Also as they pretty much depend on each other I thought it is better to keep 
them together.

--
Péter
