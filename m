Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1JSMNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:13:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46928 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377Ab1JSMNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:13:43 -0400
Date: Wed, 19 Oct 2011 13:13:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v3 2/8] ASoC: da7210: Add support for DAPM
Message-ID: <20111019121341.GE3107@opensource.wolfsonmicro.com>
References: <1318590098.12107.509.camel@matrix>
 <20111014192008.GD2931@opensource.wolfsonmicro.com>
 <1318666803.613.21.camel@matrix>
 <20111017214107.GC5200@opensource.wolfsonmicro.com>
 <1319008895.7230.11.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319008895.7230.11.camel@matrix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 12:51:35PM +0530, Ashish Chavan wrote:

> BTW if in case, hardware designers reiterate to use STANDBY registers,
> will it suffice to only document this somewhere is the source?

The main thing is to make sure that the code is understandable and
doesn't look buggy to visual inspection so yes, if there's adequate
documentation that would be OK.
