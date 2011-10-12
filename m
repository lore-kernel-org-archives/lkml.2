Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1JLIFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:05:08 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:58887 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab1JLIFG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:05:06 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: Re: Re: [PATCH v2 2/6] MFD: twl6040: Cache the vibra control registers
Date: Wed, 12 Oct 2011 11:05:06 +0300
Message-ID: <2188183.hGjzCdyui0@barack>
User-Agent: KMail/4.7.2 (Linux/3.0.4-gentoo; KDE/4.7.2; x86_64; ; )
In-Reply-To: <20111011160142.GB10286@core.coreip.homeip.net>
References: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com> <20111011144824.GE1098@sirena.org.uk> <20111011160142.GB10286@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 October 2011 09:01:42 Dmitry Torokhov wrote:
> I'm OK with all patches going through MFD - I do not believe it will
> cause any merge issues.

Thanks Dmitry.

> For the record I still do not like returning EBUSY when device is not
> available - I think if device can't serve any requests it should not
> exists at all.

While I tend to agree with this, in embedded systems this might (not 
certainly) cause issues. Embedded SW (middleware, high level) tends to take 
the underlaying HW as static.
Before I can do the dynamic input device creation/destruction I need to make 
sure that the userspace is ready for this.
I'm planning to address your concern regarding to twl6040, and at the same 
time I'm going to change the twl4030 vibra/MFD/audio driver to behave in a 
same way.

--
Péter
