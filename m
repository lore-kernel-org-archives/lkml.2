Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1ITLYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 07:24:01 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33969 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab1ITLYA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 07:24:00 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, Dmitry Torokhov <dtor@mail.ru>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: Re: Re: [alsa-devel] [PATCH 7/8] ASoC: omap-mcpdm: Correct the supported number of channels
Date: Tue, 20 Sep 2011 14:24:05 +0300
Message-ID: <1703825.IkgE7UOG84@barack>
User-Agent: KMail/4.7.1 (Linux/3.0.4-gentoo; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1661734.tddAioOORG@barack>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com> <20110920105714.GA14609@sirena.org.uk> <1661734.tddAioOORG@barack>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 September 2011 14:10:24 Péter Ujfalusi wrote:
> On Tuesday 20 September 2011 11:57:14 Mark Brown wrote:
> > No I didn't - I guess this one only applies against Liam's tree
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Hrm, I have used Linus's tree for this series, and AFAIK there were no
> changes regarding to McPDM apart from the patches I have submitted.
> 
> Could you give me a hint, why it failed?

I know why it fails.
We need to have the new McPDM driver patches for this to apply.

--
Péter
