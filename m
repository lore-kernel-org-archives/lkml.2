Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab0IKTeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 15:34:08 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40413 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0IKTeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 15:34:07 -0400
Date: Sat, 11 Sep 2010 21:34:04 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/SubmittingPatches: Add and describe
 scripts/get_maintainer.pl
Message-ID: <20100911213404.60c8cefa@schatten.dmk.lab>
In-Reply-To: <1284232943.12180.97.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100910095259.GC23903@sirena.org.uk>
	<1284113066.1783.69.camel@Joe-Laptop>
	<20100910101818.GF3068@rakim.wolfsonmicro.main>
	<1284115665.1783.144.camel@Joe-Laptop>
	<1284164541.1783.204.camel@Joe-Laptop>
	<20100911113811.7c685c6d@schatten.dmk.lab>
	<1284198750.12180.18.camel@Joe-Laptop>
	<20100911120243.7cce451e@schatten.dmk.lab>
	<1284232943.12180.97.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Sep 2010 12:22:23 -0700
Joe Perches <joe@perches.com> wrote:

> +./scripts/get_maintainers.pl options "--rolestats" and "--git-blame"
> +can show a bit more information and might help you select the appropriate
> +parties to CC.

typo. s/maintainers/maintainer/
