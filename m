Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1HJRZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:25:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:50448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1HJRZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:25:40 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Wed, 10 Aug 2011 18:25:33 +0100
In-Reply-To: <20110810100130.6adc6c99.rdunlap@xenotime.net>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <1312067670.22074.61.camel@i7.infradead.org>
	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	 <4E34998D.8060806@zytor.com>
	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	 <4E4140B3.7090802@suse.cz>
	 <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
	 <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>
	 <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
	 <20110810100130.6adc6c99.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312997135.2989.54.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 10:01 -0700, Randy Dunlap wrote:
> On Wed, 10 Aug 2011 10:15:55 -0400 Arnaud Lacombe wrote:
> 
> > Btw, warning about potential missing dependencies are useless[0],
> > user, even kernel hacker do _not_ read them. We spent a few day
> > tracking down a build failure on powerpc triggered because SND_ISA was
> > selected without ISA_DMA_API, a warning was present, but nobody cared
> > about it.
> 
> That one was an anomaly.  I usually see them and often send patches
> for them.  But granted, most developers just pass over them. 

I see that kind of thing as a natural consequence of the whole 'select'
abomination. But that's even *further* off-topic from the original topic
of this thread than Arnaud has already dragged us.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

