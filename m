Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760Ab1LPXrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:47:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58038 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1LPXq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:46:57 -0500
Date: Fri, 16 Dec 2011 21:46:47 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Brian Gitonga Marete <marete@toshnix.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
Message-ID: <20111216234647.GA25813@infradead.org>
References: <20111020130041.GB1772@ghostprotocols.net>
 <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
 <CAHVUoiTeCuFLCkyEzCMJ6g1wAp+FWDR3qkSrqE3vJAYwLsRC9Q@mail.gmail.com>
 <20111130181011.GA4111@infradead.org>
 <CAHVUoiQC5RjuHUsfPVTQ_C+W0Khp=hQC+_csP0+fJgUnoaALAA@mail.gmail.com>
 <20111201141130.GA2323@infradead.org>
 <CAHVUoiR=gMcdLZcR+TmB6CiRhEP+x8aXjR5r5Wc4k6gZwzLAjg@mail.gmail.com>
 <20111206134431.GA10709@infradead.org>
 <CAHVUoiSaOMeyZ45KF0B=aiqC5DGF0Jk+te7F=UNTN6t4QiPcRQ@mail.gmail.com>
 <CAHVUoiT-tyHikZ6E-08Pxoy-inquTMyO+E3qajtRGun1Y0_adA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVUoiT-tyHikZ6E-08Pxoy-inquTMyO+E3qajtRGun1Y0_adA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 16, 2011 at 01:04:14AM +0300, Brian Gitonga Marete escreveu:
> Looking at the code, it seems that the connection between the TUI
> interface and the core (where the crash occurs) is that the TUI
> interface activates the annotation code which otherwise is not run. So
> the bug is probably in the annotation code? Or in the version of the
> binary (ELF) decoding libraries that are on my system -- Ubuntu 10.10

I'm travelling, so I was unable to work on this report. I should've
already, and thank you for investigating it further.

While doing presentations about perf on an Atom (32 bit) machine I
noticed crashes while collecting callchains.

Are your crashes noticed on 32-bit or 64-bit?

I'll try to get it fixed as soon as I get back home.

- Arnaldo
