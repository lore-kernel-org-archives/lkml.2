Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1EQODF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:03:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57327 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1EQODD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nvDSZd2VN3XVXEvPe7RDDThQnAerIjh4sC281/zyZga6vsYJXDzk0OaeHFJih1VEJa
         fAo6MAJag9cGNT+VTsaVL9cgH+vuWt9Ik4+NRLPrqCjsBZc9Izl3M7eIbbQeFEEeuT//
         PHQyDOjF3tLRyO9V8i9Ua/n9cc4bsfwWZX7UM=
Date: Tue, 17 May 2011 16:02:33 +0200
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch V3] percpu_counter: scalability works
Message-ID: <20110517140233.GP20624@htj.dyndns.org>
References: <1305609768.2375.84.camel@sli10-conroe>
 <1305622861.2850.21.camel@edumazet-laptop>
 <20110517091102.GE20624@htj.dyndns.org>
 <1305625541.2850.29.camel@edumazet-laptop>
 <20110517095001.GF20624@htj.dyndns.org>
 <1305634807.2850.89.camel@edumazet-laptop>
 <20110517124528.GN20624@htj.dyndns.org>
 <1305637223.2850.95.camel@edumazet-laptop>
 <20110517130414.GO20624@htj.dyndns.org>
 <alpine.DEB.2.00.1105170853520.11187@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105170853520.11187@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, May 17, 2011 at 08:55:33AM -0500, Christoph Lameter wrote:
> Well lets just adopt the system that vm statistics use. Bound the error by
> time and batch and allow the user to change the batch if more accuracy is
> desired.

Yeah, that would be the better long term solution.

> The _sum function is optional and should it should be explained that the
> result *could* be better but dont count on it.

We can implement force-flush for dire situations, similar to expedited
RCU flush thing.

Thanks.

-- 
tejun
