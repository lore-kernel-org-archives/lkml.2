Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab0ENL5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:57:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42581 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304Ab0ENL5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oP/vHKVEeuN2XJ7RFuWbZ+TpfYcFxw3O3vMRxC6WqZnkJ6SFheMuOua1WYtFaE2YBR
         WUv7A5iIMkCgtMvGpFoa3N1QZORuQZdAaPq5/XjGAXXpObdrDxTq9plT883kqw2cMV8k
         +plqh4nJZLiBiHwfrgzLHOsd7EvxYZRFDC/jc=
MIME-Version: 1.0
In-Reply-To: <1273833535.1626.242.camel@laptop>
References: <4BEAB6FC.8090105@intcomgrp.com>
	 <20100512190757.GA421@tango.0pointer.de>
	 <1273755719.5605.3537.camel@twins>
	 <20100513140354.GA12639@tango.0pointer.de>
	 <1273785546.5605.3556.camel@twins>
	 <20100514000252.GB30093@tango.0pointer.de>
	 <20100514054336.GX3296@balbir.in.ibm.com>
	 <1273820028.5605.3565.camel@twins>
	 <20100514081248.GE3296@balbir.in.ibm.com>
	 <1273833535.1626.242.camel@laptop>
Date: Fri, 14 May 2010 13:57:14 +0200
Message-ID: <AANLkTimoTCcDgb9rn7GBhV8PfeOwDNU74GF732inhuSU@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, Lennart Poettering <mzxreary@0pointer.de>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, jsafrane@redhat.com, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 12:38 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-05-14 at 13:42 +0530, Balbir Singh wrote:
>
>> Heh! agreed, but we are a small population and moreover a large
>> population would benefit from systemd and parallel boot.
>
> CONFIG_CGROUP=y isn't a requirement for parallel boot. People have been
> doing that for years without it.
>
> And I'm not against systemd using cgroups per-se, I'm against it
> mandating it. It could simply not use them and not provide whatever it
> needs them for when not present.
>
> CONFIG_CGROUP is an option, so people can say no.
>

I think that is reasonable. There should be a fallback for folks who
want to run their own kernel (though I cannot imagine why they would
want to turn off cgroups ;-) ).

Thanks!
Dhaval
