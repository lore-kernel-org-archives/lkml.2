Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1AUJ0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:26:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39988 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1AUJ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:26:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cdtzRJC/68WBub193k5IYJWkwWWqqxP483NoGPFuBdE4RP74ZOJ8usfGHSQXBnqKSV
         8Wyu272IF62x/XcHdcfBTR4bRujPH/KqWqX1rS3rp7k6JBC8rsiAt0TU5MJU8jFQO05b
         +mCCf3saPkUrsmDCMVxtv5e4O8IHPJvpFa+wo=
Date: Fri, 21 Jan 2011 10:26:49 +0100
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110121092649.GA2832@htj.dyndns.org>
References: <20110106204513.669098445@linux.com>
 <20110106204525.222395863@linux.com>
 <4D263C91.30709@zytor.com>
 <alpine.DEB.2.00.1101070907060.3014@router.home>
 <20110107180419.GB23082@Krystal>
 <alpine.DEB.2.00.1101071227450.3014@router.home>
 <20110108172453.GF13269@mtj.dyndns.org>
 <4D393636.4040607@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D393636.4040607@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 21, 2011 at 09:31:02AM +0200, Pekka Enberg wrote:
> On 1/8/11 7:24 PM, Tejun Heo wrote:
> >Call me weird but I like this one than others.  It sure is ugly but
> >the operation itself isn't a particularly pretty so it kinda matches.
> >Also, this one is the least error prone and more consistent with other
> >cpu ops.
> 
> So what are we going to do about this patch? I'd love to merge
> Christoph's SLUB patches for linux-next now that .38-rc1 is out.

At least you like it, which is good.

I don't think the currently proposed one with two separate parameters
is significantly better than other alternatives and vice-versa.  They
all have slightly different ugliness and error proneness issues.

That said, I still like the double parameter one best, and, unless
there are distinctively good reasons to choose another one, I'm gonna
commit it to percpu tree in a few days so that merge can proceed.  So,
if you have something to say, now would be a good time to assert it.

Thank you.

-- 
tejun
