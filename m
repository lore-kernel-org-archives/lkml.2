Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1F1Ns7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 09:48:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55026 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab1F1Nrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:47:55 -0400
Date: Tue, 28 Jun 2011 09:47:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bastian Blank <waldi@debian.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 2/2] xen: Add alias to autoload backend
 drivers
Message-ID: <20110628134727.GD7777@dumpdata.com>
References: <20110624215155.GB4735@wavehammer.waldi.eu.org>
 <20110627161327.GO6978@dumpdata.com>
 <20110627163728.GA23028@wavehammer.waldi.eu.org>
 <20110627165109.GB13335@dumpdata.com>
 <20110627165711.GA2201@dumpdata.com>
 <20110627172305.GC23028@wavehammer.waldi.eu.org>
 <20110627173447.GD2430@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627173447.GD2430@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4E09DB7D.00DE:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 01:34:47PM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 27, 2011 at 07:23:05PM +0200, Bastian Blank wrote:
> > On Mon, Jun 27, 2011 at 12:57:11PM -0400, Konrad Rzeszutek Wilk wrote:
> > > Ugh actually no I can't.
> > 
> > Why? It does not actually change things.

There are two ways of doing this:

1). Split the patch in three b/c:

The backends are owned by different maintainers. The xen-netback
is owned by David Miller and he is the one that will take the patch and send
it to Linus during the next merge window. The xen-blkback is the same thing -
Jens will take it (or I can stick it in my #stable/for-jens branch and ask
him to pull everything there). Either way, for both backends, those two
folks are the ones that Linus will take the patch from - not me.

I am going to take the xenbus patches and ask Linus to pull them.

In other words, this last patch crosses three different maintainers - hence
you can either split the patch in three parts.

2). Ask each of the maintainers (David, Jens) to give you an Ack so that
this patch has both of them and then I can send it directly to Linus.

