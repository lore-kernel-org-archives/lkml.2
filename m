Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1AURTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:19:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45936 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1AURTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uqxPTr1ivyyBu/cY2i+KARDL2a8zbXm0Xvpxy9K50rSDwa8u/9ryPPjdyJS8y3S8Uf
         2BqRRdZ0hdnVxdVhvOFAZsOJ+W3V56Dl0Y7BLUkDbtoo/N5s52F5OnPwnYXfdHGAGg6d
         bhNyLMj29EuHA5oLVY+DYBNxgJ4xAo9TxW4dU=
Date: Fri, 21 Jan 2011 18:19:14 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110121171914.GJ2832@htj.dyndns.org>
References: <20110107180419.GB23082@Krystal>
 <alpine.DEB.2.00.1101071227450.3014@router.home>
 <20110108172453.GF13269@mtj.dyndns.org>
 <4D393636.4040607@cs.helsinki.fi>
 <20110121092649.GA2832@htj.dyndns.org>
 <4D39A6EB.70705@zytor.com>
 <20110121154831.GE2832@htj.dyndns.org>
 <20110121165425.GB11687@Krystal>
 <20110121170847.GH2832@htj.dyndns.org>
 <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 09:13:41AM -0800, H. Peter Anvin wrote:
> We could do cmpxchg with a structure... the problem with a lon int
> type is that Cristoph ran into bugs with __int128 on 64 bits.

But, IIRC, the problem with int128 was with passing it as parameter
and return value.  We don't have to do that.  We'll be just using it
as a data storage / container type.  Or even that is broken?

Thanks.

-- 
tejun
