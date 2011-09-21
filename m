Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1IUNDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:03:48 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52995 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510Ab1IUNDs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:03:48 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: Re: Re: Re: [PATCH 07/17] ASoC: twl6040: Lower the initial gains
Date: Wed, 21 Sep 2011 16:03:49 +0300
Message-ID: <25343507.X6coeDXaUn@barack>
User-Agent: KMail/4.7.1 (Linux/3.0.4-gentoo; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20110921123931.GD4374@opensource.wolfsonmicro.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com> <2240573.6cRWXtKJB6@barack> <20110921123931.GD4374@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 September 2011 13:39:31 Mark Brown wrote:
> The key problem here is that you sent a change saying "change the
> default volume" with no other context in either the changelog or the
> code.  If you've got code that's actively managing the volume register
> while presenting a nice view to the application layer so that the
> register value isn't directly seen in the way it is for standard ASoC
> controls that's a very different thing to standard code.  I'm not going
> to remember the details of everything in every CODEC driver.
> 
> > We do have other scenarios covered, but this initialization was missing.
> > This resulted that the _first_ playback has pop noise, but all
> > subsequent playbacks were fine, since we had the runtime fix for this.
> 
> So what you're doing here is really a bug fix for the ramping code.

I will update the commit message, and I'll also put a comment to the code to 
explain it clearly.

--
Péter
