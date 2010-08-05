Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611Ab0HEOhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:37:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56716 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab0HEOhr (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 5 Aug 2010 10:37:47 -0400
Date: Thu, 5 Aug 2010 10:37:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 4, add a new git tree please?
Message-ID: <20100805143732.GA5697@phenom.dumpdata.com>
References: <20100804151035.14678528.sfr@canb.auug.org.au>
 <20100804222350.GA2220@phenom.dumpdata.com>
 <20100805103050.3c201cdd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805103050.3c201cdd.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C5ACCB5.004C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:30:50AM +1000, Stephen Rothwell wrote:
> Hi Konrad,
> 
> On Wed, 4 Aug 2010 18:23:50 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >
> > I was wondering if you could add in your awesome tool this extra git
> > tree:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
> > 
> > (the head of it please)
> > 
> > It has this patchset: http://lkml.org/lkml/2010/7/27/246
> > 
> > that I have been carrying in 
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git
> > 
> > but I realized it should probably not be in the swiotlb and was hence
> > wondering if you would be OK adding in that extra git tree?
> 
> Added from today, but only because everything in it is already in
> linux-next from your other tree.  I assume that you will remove this stuff
> from there.

Yes.

Looking at your linux-next tree it looks that you added the wrong tree.
You added 'xen-2.6.git' while in actuallity the tree is 'xen.git'.
Could you change it please? Thanks.
