Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1AUQfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:35:01 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35009 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1AUQe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:34:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G4u8j/q70S8mmcxe4PCw9m7HtAdLNFQaSOkK+kiYYBEZ82b+TgQeIHcWKo6+0dk0UY
         kSKerfLSJaNxQJkBKjB7LbXXQZvlNF8pk7XuczN7Em1toTv0p32vGTQwvqXh4x9Imd6G
         rnYqOfHSAPZO7s1ImWFJS0crtKq3C6QFpfYOk=
Date: Fri, 21 Jan 2011 17:34:54 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110121163454.GF2832@htj.dyndns.org>
References: <4D263C91.30709@zytor.com>
 <alpine.DEB.2.00.1101070907060.3014@router.home>
 <20110107180419.GB23082@Krystal>
 <alpine.DEB.2.00.1101071227450.3014@router.home>
 <20110108172453.GF13269@mtj.dyndns.org>
 <4D393636.4040607@cs.helsinki.fi>
 <20110121092649.GA2832@htj.dyndns.org>
 <4D39A6EB.70705@zytor.com>
 <20110121154831.GE2832@htj.dyndns.org>
 <c661a1e2-4e08-4e6b-b2c8-93e231be981f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c661a1e2-4e08-4e6b-b2c8-93e231be981f@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 08:30:41AM -0800, H. Peter Anvin wrote:
> There is a technical argument: any noninline version will have
> actual code overhead.

But the type checking and all those stuff have to be macros anyway.
If out-of-line implementation is necessary, it can take whatever
parameter to optimize performance from the frontend macro.

Thanks.

-- 
tejun
