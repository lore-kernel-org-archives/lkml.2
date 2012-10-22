Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2JVODw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:03:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:53635 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2JVODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:03:50 -0400
Date: Mon, 22 Oct 2012 07:03:39 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] perf: Build install-man target when installing
Message-ID: <20121022140339.GA8775@ghostprotocols.net>
References: <20120925174658.GD9320@aftab.osrc.amd.com>
 <1348854427-12746-1-git-send-email-bp@amd64.org>
 <20121020111625.GB17563@liondog.tnic>
 <87mwzfj7dn.fsf@sejong.aot.lge.com>
 <20121022100719.GA8352@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022100719.GA8352@liondog.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 22, 2012 at 12:07:19PM +0200, Borislav Petkov escreveu:
> On Mon, Oct 22, 2012 at 04:25:24PM +0900, Namhyung Kim wrote:
> > It will add additional dependencies of asciidoc, docbook-xsl and/or
> > something to default perf install command. I don't know it matters
> > much, but just wanted to say. What if a user want to install the perf
> > but the required packages for documents are not installed?
 
> Ok, this is a valid point, more or less.

Yes, its a valid point, to address it I think we should just do as we
with other features, like, say, when python-devel is not installed warn
the user that python support won't be included, i.e. if asciidoc, etc
are not installed, tell the user that documentation will not be
installed, install package A, B and C to have documentation installed.

- Arnaldo
