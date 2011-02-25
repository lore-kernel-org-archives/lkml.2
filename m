Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1BYN0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 08:26:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36065 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab1BYN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 08:26:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qufl05jdaSXrD6WhRYR6XRKjBb/eG5ZWtNMGp4S2SvioixtmhnZwdIzltQK2jrbGFs
         l/iTPalEhsPVnhYp1y4RqIttv64yCvatL+Dolt8ReEHmDI25RXVRVidMUh9rmY5lc7TC
         YTRdRHIHOexUmpLQrTZLcRjagMrQxttapx1Z8=
Date: Fri, 25 Feb 2011 14:19:49 +0100
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110225131949.GJ24828@htj.dyndns.org>
References: <4D393636.4040607@cs.helsinki.fi>
 <20110121092649.GA2832@htj.dyndns.org>
 <4D39A6EB.70705@zytor.com>
 <20110121154831.GE2832@htj.dyndns.org>
 <20110121165425.GB11687@Krystal>
 <20110121170847.GH2832@htj.dyndns.org>
 <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
 <20110121171914.GJ2832@htj.dyndns.org>
 <4D3D15AF.30508@zytor.com>
 <4D67AA06.5090200@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D67AA06.5090200@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 03:09:26PM +0200, Pekka Enberg wrote:
> On Fri, Jan 21, 2011 at 09:13:41AM -0800, H. Peter Anvin wrote:
> >>>We could do cmpxchg with a structure... the problem with a lon int
> >>>type is that Cristoph ran into bugs with __int128 on 64 bits.
> 
> On 01/21/2011 09:19 AM, Tejun Heo wrote:
> >>But, IIRC, the problem with int128 was with passing it as parameter
> >>and return value. We don't have to do that. We'll be just using it
> >>as a data storage / container type. Or even that is broken?
> 
> On 1/24/11 8:01 AM, H. Peter Anvin wrote:
> >Well, part of the point was to pass in registers.
> >
> >No idea on the data storage type.
> 
> Ping? The current situation is that we're unable to merge a
> perfectly good SLUB performance optimization because we can't seem
> to agree on the this_cpu_cmpxchg_double() API.

I thought cl was preparing new version of the patchset.  Christoph?

-- 
tejun
