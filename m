Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1FPNCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:02:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54374 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab1FPNCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:02:04 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Tejun Heo <tj@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: Re: Re: Re: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040 vibrator
Date: Thu, 16 Jun 2011 17:06:00 +0300
Message-ID: <4306005.scnJ1lQX4P@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110616120244.GA2611@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com> <5476342.2jZLF0UGcI@barack> <20110616120244.GA2611@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday 16 June 2011 14:02:44 Tejun Heo wrote:
> > I'll move to create_workqueue.
> 
> I suppose you meant alloc_workqueue()? :)

Oh, yes. I mean that.
 
> Sorry about the confusing names, I'm still in the (slow) process of
> deprecating older APIs.

Will do this soon, and I ping the other maintainers, if they see other issues 
with the series, so I can make the change at the same time.

Thanks,
Péter
