Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2GaQN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:13:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56092 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202Ab2GaQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:13:27 -0400
Date: Tue, 31 Jul 2012 17:13:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Liam Girdwood <lrg@ti.com>, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [ 35/73] ASoC: dapm: Fix locking during codec shutdown
Message-ID: <20120731161325.GD11892@opensource.wolfsonmicro.com>
References: <20120731044310.013763753@decadent.org.uk>
 <20120731044316.865191013@decadent.org.uk>
 <20120731161100.GB3111@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731161100.GB3111@herton-Z68MA-D2H-B3>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 01:11:01PM -0300, Herton Ronaldo Krzesinski wrote:

> Hi, this doesn't build on 3.2:

> linux-stable/sound/soc/soc-dapm.c: In function 'soc_dapm_shutdown_codec':
> linux-stable/sound/soc/soc-dapm.c:2982:18: error: 'struct snd_soc_card' has no member named 'dapm_mutex'
> linux-stable/sound/soc/soc-dapm.c:3007:20: error: 'struct snd_soc_card' has no member named 'dapm_mutex'

> Looking at it, I'm not sure the fix is needed on 3.2, and introducing
> dapm_mutex would be several changes.

Yes, this is irrelevant on v3.2.
