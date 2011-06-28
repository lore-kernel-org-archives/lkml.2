Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1F1GpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:45:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53523 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1F1Goc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:44:32 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Re: Re: [PATCH v6 00/18] MFD/ASoC/Input: TWL4030/TWL60X0 changes
Date: Tue, 28 Jun 2011 09:44:22 +0300
Message-ID: <7290395.1hzL9xckCf@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110628061721.GY23145@atomide.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com> <2519112.D3nfO1VTXY@barack> <20110628061721.GY23145@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tuesday 28 June 2011 08:17:21 Tony Lindgren wrote:
> OK. Assuming Samuel is fine with the patches, care to put
> together a branch against devel-cleanup for me to pull?

While waiting for Samuel, I can start preparing the branch for you, since the 
bulk of the conflicts are in mach-omap2, should not affect the MFD parts.
Can I add your ack to the mach-omap2 parts, or are you prefer to handle this 
yourself?

-- 
Péter
