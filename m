Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1F0Rfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:35:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23730 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1F0Rfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:35:41 -0400
Date: Mon, 27 Jun 2011 13:34:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bastian Blank <waldi@debian.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 2/2] xen: Add alias to autoload backend
 drivers
Message-ID: <20110627173447.GD2430@dumpdata.com>
References: <20110624215155.GB4735@wavehammer.waldi.eu.org>
 <20110627161327.GO6978@dumpdata.com>
 <20110627163728.GA23028@wavehammer.waldi.eu.org>
 <20110627165109.GB13335@dumpdata.com>
 <20110627165711.GA2201@dumpdata.com>
 <20110627172305.GC23028@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627172305.GC23028@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E08BF43.0032:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 07:23:05PM +0200, Bastian Blank wrote:
> On Mon, Jun 27, 2011 at 12:57:11PM -0400, Konrad Rzeszutek Wilk wrote:
> > Ugh actually no I can't.
> 
> Why? It does not actually change things.
> 
> > Can you re-submit these two patches (and stick on Acked-by Ian on them) and
> > split the "xen: Add alias to autoload backend driver" in three patches:
> >  1) the xen-netback (and copy David Miller)
> >  2) the xen-blkback (and copy Jens Axboe)
> >  3) the xenbus one
> 
> That is silly.

Please do it.

> 
> > That should be five patches total.
> 
> No, 2+2 is 4, not five.

Right. Got my math wrong.
