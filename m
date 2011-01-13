Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1AMBYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:24:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47227 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab1AMBYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:24:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M0CbJtlpEaBJVGrCWnvarTkBmnr21IC+8A3z+eSWeFhqarWVP0SEqkQE1NAGJL3kq3
         x/6ubCX+ycqYqCWKxKuXTPRTFy/bH3xXJaNMHLwqzrBCknFHXk+ATWVFAE0Ym2B/th3C
         TamL3+YCepGBR54kIyhWY9YVOJjWuRrBena3U=
MIME-Version: 1.0
In-Reply-To: <20110112231602.GH17328@linux.vnet.ibm.com>
References: <20110111101040.GD4772@in.ibm.com>
	<20110111101153.GE4772@in.ibm.com>
	<20110111124658.GA4507@zhy>
	<20110111134244.GJ4772@in.ibm.com>
	<20110111140005.GA6069@zhy>
	<20110112074930.GF2723@in.ibm.com>
	<1294831112.19601.8.camel@laptop>
	<20110112231602.GH17328@linux.vnet.ibm.com>
Date: Thu, 13 Jan 2011 09:24:33 +0800
Message-ID: <AANLkTikipMxFe8xoFtfaB4yhnQQe5vH9bHvL3z6MK9rN@mail.gmail.com>
Subject: Re: [PATCH -tip 1/2] [PATCH -tip 1/2] sched: Reinstate group names in /proc/sched_debug.
From: Yong Zhang <yong.zhang0@gmail.com>
To: paulmck@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 7:16 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Jan 12, 2011 at 12:18:32PM +0100, Peter Zijlstra wrote:
>> Not only is it not recommended, its a flat out bug for PREEMPT_RCU.
>
> And lockdep-RCU will yell at you under PREEMPT_RCU, which will result
> in Miles Lane yelling at me.  ;-)


Thanks Peter and Paul for pointing this.
I will take a look at PREEMPT_RCU ;)

Thanks,
Yong

-- 
Only stand for myself
