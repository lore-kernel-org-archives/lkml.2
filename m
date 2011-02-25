Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab1BYQhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:37:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53102 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586Ab1BYQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:37:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rj87qTcr0Hk3+V33vtqL13ZZrc6J1BBCqlQYr8PUrRrQD8Af5K/WOHkIIP6Jhs7+NB
         glCsusk2PPFlc33zit9lC4G33SiWKwyef+a/4TWfwxSNKwZmpAAG6vo+Ve3IPylHrPxD
         +YP8AmVYmkchj8UH3nFeg1DB+DDWS7zbJH7Kg=
Date: Fri, 25 Feb 2011 17:37:40 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110225163740.GS24828@htj.dyndns.org>
References: <4D39A6EB.70705@zytor.com>
 <20110121154831.GE2832@htj.dyndns.org>
 <20110121165425.GB11687@Krystal>
 <20110121170847.GH2832@htj.dyndns.org>
 <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
 <20110121171914.GJ2832@htj.dyndns.org>
 <4D3D15AF.30508@zytor.com>
 <4D67AA06.5090200@cs.helsinki.fi>
 <20110225131949.GJ24828@htj.dyndns.org>
 <alpine.DEB.2.00.1102251025250.4996@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102251025250.4996@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:26:43AM -0600, Christoph Lameter wrote:
> On Fri, 25 Feb 2011, Tejun Heo wrote:
> 
> > > Ping? The current situation is that we're unable to merge a
> > > perfectly good SLUB performance optimization because we can't seem
> > > to agree on the this_cpu_cmpxchg_double() API.
> >
> > I thought cl was preparing new version of the patchset.  Christoph?
> 
> In order to do that I would have to see a way to improve the
> patches. None of the suggestions so far seem to be realizable.

I see.  For some reason, I thought you and hpa agreed on something and
you were writing up the patches.  I'll read the thread again.  Let's
just pick one.  It's not like this is an API which will be used
througout the tree.

Thanks.

-- 
tejun
