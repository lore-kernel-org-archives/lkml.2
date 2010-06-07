Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab0FGMk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:40:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48739 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752641Ab0FGMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:40:54 -0400
Date: Mon, 7 Jun 2010 13:40:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: sonic zhang <sonic.adi@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH v6] regulator: new drivers for AD5398 and AD5821
Message-ID: <20100607124052.GB13287@rakim.wolfsonmicro.main>
References: <1275626446.1515.5.camel@eight.analog.com>
 <20100607122840.GA13287@rakim.wolfsonmicro.main>
 <AANLkTilkzx3eQXc-cOEauj_v0_mZFmh_BVUMw1sgJ1_j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilkzx3eQXc-cOEauj_v0_mZFmh_BVUMw1sgJ1_j@mail.gmail.com>
X-Cookie: Warp 7 -- It's a law we can live with.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 08:39:28AM -0400, Mike Frysinger wrote:

> i guess the Blackfin I2C driver should have its initcall bumped up as well

Yes, probably.  SPI might be worth it also.
