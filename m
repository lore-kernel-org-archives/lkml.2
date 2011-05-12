Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1ELJFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:05:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52801 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1ELJFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:05:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aKY59aFH4w405EO5D2yu1jI44tbCxsyMZWZYuerPbRiG4AXkaWYncFEInp/LaOcztz
         3oMirF2LhH0QmqmDM55d3aviiBugxZ8w64fTZFHF8F23leIixG1TF0eNo7akmB61Ltvb
         8YD7ji7Zkkf4y8ccv5lDzT9JTKMUvfc7g2eWg=
Date: Thu, 12 May 2011 11:05:34 +0200
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
Message-ID: <20110512090534.GE1030@htj.dyndns.org>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
 <20110511092848.GE1661@htj.dyndns.org>
 <1305168493.2373.15.camel@sli10-conroe>
 <20110512082159.GB1030@htj.dyndns.org>
 <1305190520.2373.18.camel@sli10-conroe>
 <20110512085922.GD1030@htj.dyndns.org>
 <1305190936.3795.1.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305190936.3795.1.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 12, 2011 at 11:02:15AM +0200, Eric Dumazet wrote:
> > I don't think @maxfuzzy is necessary there.  I wrote this before but
> > why can't we track the actual deviation instead of the number of
> > deviation events?
> 
> Thats roughly same thing (BATCH multiplicator factor apart)
> 
> Most percpu_counter users for a given percpu_counter object use a given
> BATCH, dont they ?

Well, @maxfuzzy is much harder than @batch.  It's way less intuitive.
Although I haven't really thought about it that much, I think it might
be possible to eliminate it.  Maybe I'm confused.  I'll take another
look later but if someone can think of something, please jump right
in.

Thanks.

-- 
tejun
