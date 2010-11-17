Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0KQXtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:49:23 -0500
Received: from mail.perches.com ([173.55.12.10]:1507 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0KQXtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:49:22 -0500
Subject: Re: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
From: Joe Perches <joe@perches.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101117220737.2d3d7356@stein>
References: <20101116104921.GL12986@rakim.wolfsonmicro.main>
	 <1289919077.28741.50.camel@Joe-Laptop>
	 <20101116183707.179964dd@schatten.dmk.lab>
	 <20101116181226.GB26239@rakim.wolfsonmicro.main>
	 <20101116203522.65240b18@schatten.dmk.lab>
	 <20101116195530.GA7523@rakim.wolfsonmicro.main>
	 <20101116122102.86e7e0b9.rdunlap@xenotime.net>
	 <20101116230126.GB24623@opensource.wolfsonmicro.com>
	 <20101117014427.41d85b13@stein>
	 <alpine.LNX.2.00.1011170150060.7420@pobox.suse.cz>
	 <20101117170746.GB19488@rakim.wolfsonmicro.main>
	 <20101117220737.2d3d7356@stein>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 15:49:19 -0800
Message-ID: <1290037759.28741.313.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 22:07 +0100, Stefan Richter wrote:
> So, if this boring thread does at least yield the conclusion that
> ${path}/${filename}: is a bad title prefix, at least something was
> won. :-)

I've changed my scripts to use this style:

Subject: [PATCH] $(basename $(dirname $file)): commit desc... 

until a better tool is available.

