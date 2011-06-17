Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1FQJzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:55:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59637 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab1FQJzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:55:48 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Tejun Heo <tj@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: Re: Re: [alsa-devel] [PATCH v4 11/18] input: Add initial support for TWL6040 vibrator
Date: Fri, 17 Jun 2011 13:59:47 +0300
Message-ID: <1541792.uUz2bSMDMl@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110617094332.GE2611@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com> <5740779.B2nyl9oMW4@barack> <20110617094332.GE2611@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 June 2011 11:43:32 Tejun Heo wrote:
> Just use the default params
> 
> 	alloc_workqueue("twl6040-vibra", 0, 0);
> 
> Thanks.

I'll do this for the next posting

Thanks,
Péter
