Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1CFWwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 17:52:17 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:50121 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab1CFWwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 17:52:16 -0500
Date: Sun, 6 Mar 2011 23:52:10 +0100
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: Tree for March 4
Message-ID: <20110306225210.GA9085@mako-laptop>
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sound/soc/soc-core.c: In function 'snd_soc_instantiate_card':
sound/soc/soc-core.c:1882: error: 'struct snd_soc_dapm_context' has no member named 'debugfs_dapm'
sound/soc/soc-core.c:1883: error: 'struct snd_soc_card' has no member named 'debugfs_card_root'
sound/soc/soc-core.c:1884: error: 'struct snd_soc_dapm_context' has no member named 'debugfs_dapm'

Looking at surrounding code it's missing ifdef for CONFIG_DEBUG_FS.

-- 
Mariusz Kozlowski
