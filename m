Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0HDW0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:26:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40027 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab0HDW0S (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 18:26:18 -0400
Date: Wed, 4 Aug 2010 18:24:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for August 4, add a new git tree please?
Message-ID: <20100804222439.GB2220@phenom.dumpdata.com>
References: <20100804151035.14678528.sfr@canb.auug.org.au>
 <20100804222350.GA2220@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804222350.GA2220@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C59E904.00E1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 06:23:50PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 04, 2010 at 03:10:35PM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > As the merge window is open, please do not add 2.6.27 material to your
> > linux-next included trees until after 2.6.36-rc1.

Ugh. Resending as I didn't CC-ed LKML.
> 
> I was wondering if you could add in your awesome tool this extra git
> tree:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
> 
> (the head of it please)
> 
> It has this patchset: http://lkml.org/lkml/2010/7/27/246
> 
> that I have been carrying in 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git
> 
> but I realized it should probably not be in the swiotlb and was hence
> wondering if you would be OK adding in that extra git tree?
> 
> Thanks
