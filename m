Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0KEUGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:06:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46056 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0KEUGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t45lfShlCLPtLd3IfVo1AIXR95iaZHfPzxiclj79TQkOfBKuLWPVAkbQohqCUdbLE/
         v+lhZhPDTzjL7oSkeao/DecPX9Yx2ufroxtsmBkYiYQz/wIn8QoolbHkWdrHEO7hdTW2
         MZMdRjQlmIkGAtzfi+Sk8blVAMZP6kUYiq2eU=
MIME-Version: 1.0
In-Reply-To: <20101105150648.GB2850@linux.vnet.ibm.com>
References: <20101104232148.GA28037@linux.vnet.ibm.com>
	<20101105052740.GB6698@nowhere>
	<AANLkTi=RiYTsYfh9sBLBzKeZWJp8HOCP+RnOTQA-MFHL@mail.gmail.com>
	<20101105150648.GB2850@linux.vnet.ibm.com>
Date: Fri, 5 Nov 2010 16:06:35 -0400
Message-ID: <AANLkTimvMbuN7v5rwZXFywe3w-Kh_F8DVajf3JjN28V=@mail.gmail.com>
Subject: Re: dyntick-hpc and RCU
From: Dhaval Giani <dhaval.giani@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mathieu.desnoyers@efficios.com,
        dhowells@redhat.com, loic.minier@linaro.org, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, jim.houston@comcast.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Jim to the cc]

On Fri, Nov 5, 2010 at 11:06 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Nov 05, 2010 at 06:38:17AM +0100, Frederic Weisbecker wrote:
>> 2010/11/5 Frederic Weisbecker <fweisbec@gmail.com>:
>> > For now #3 seems to me more viable (with one of the adds I proposed).
>>
>> Doh, but I forgot it's not preemptable! So #2 looks then more viable.
>> Unless we can tweak #3 into getting it preemptable.
>
> There are ways of getting preemptiblity working.  This might not be
> all that big a modification to TREE_PREEMPT_RCU, now that I think
> of it.
>
>                                                        Thanx, Paul
>
