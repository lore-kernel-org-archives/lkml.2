Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2AVSfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 13:35:37 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17266 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2AVSfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 13:35:36 -0500
Date: Sun, 22 Jan 2012 13:33:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Martin Nyhus <martin.nyhus@gmx.com>
Cc: Jerome Glisse <j.glisse@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [next] Null pointer dereference in nouveau_vm_map_sg
Message-ID: <20120122183316.GA12594@phenom.dumpdata.com>
References: <201201152231.08561.martin.nyhus@gmx.com>
 <20120116203059.GC4482@homer.localdomain>
 <201201170057.51404.martin.nyhus@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201170057.51404.martin.nyhus@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F1C56F3.00AE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 12:57:50AM +0100, Martin Nyhus wrote:
> On Monday 16. January 2012 21:30:59 Jerome Glisse wrote:
> > On Sun, Jan 15, 2012 at 10:31:08PM +0100, Martin Nyhus wrote:
> > > In some cases mem will be null in nouveau_vm_map_sg, resulting in a crash
> > > at drivers/gpu/drm/nouveau/nouveau_vm.c:84. It seems to be easy enough to
> > > reproduce, so I can test patches if needed.
> > How do you trigger this ?
> 
> Opening 10-15 high-res pictures in Firefox triggers it every time. Doing the 
> same using Gimp does not, and neither does Firefox and lots of small images 
> (eg. Google image search).

I seem to be able to trigger this by using both Chrome and Firefox and 
seeing a YouTube video. I did at that time have a dual-head display, while
in the past to reproduce this I had only one monitor and it took a bit of
time before I hit it.
