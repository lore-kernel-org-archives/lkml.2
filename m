Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1IUNMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:12:42 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56008 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab1IUNMe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:12:34 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 8/8] ASoC: twl6040: Support for vibra output paths
Date: Wed, 21 Sep 2011 16:12:42 +0300
Message-ID: <3085965.EdoSnJ6VqI@barack>
User-Agent: KMail/4.7.1 (Linux/3.0.4-gentoo; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1316091561-30899-9-git-send-email-peter.ujfalusi@ti.com>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com> <1316091561-30899-9-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 15 September 2011 15:59:21 Peter Ujfalusi wrote:
> twl6040 have two vibra output drivers.
> They can be operated with audio stream coming through
> the PDM interface (fifth channel).
> The vibra outputs can be controlled via the input/FF
> driver as well.
> Selection between the two mode is implemented within
> the codec driver, the input/FF driver can only operate if
> the routing is set to "Input FF".
> Changing from "Input FF" to "Audio PDM" mode is protected
> as well: The switchin can only be done, if there is no
> running effect from the input/FF.

Can you take a look at this patch?

Thank you,
Péter
