Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1DHFOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 01:14:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53629 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1DHFOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 01:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EMnL8LlfT4ZKi/UsDrb0h2TTNgP6Sj2om8dOwbE+RxLn9gylpynVPrIM/rKrNkXS6m
         bQvXELh22aCA5VxA8bRcxzM+vDag3uhzqAYqpXAAGcvQpBtWJnGq9BkM96IkN4ayvP9E
         s1lvRdzntxcE5oDYkEd9y9NVD38zzIvHQo9iE=
MIME-Version: 1.0
In-Reply-To: <4D9E6F6E.9050709@codemonkey.ws>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<4D98716D.9040307@codemonkey.ws>
	<4D9873CD.3080207@redhat.com>
	<20110406093333.GB6465@elte.hu>
	<4D9E6F6E.9050709@codemonkey.ws>
Date: Fri, 8 Apr 2011 08:14:22 +0300
X-Google-Sender-Auth: tIHCm4MkqQzbwt-kQzpwEkv4R_U
Message-ID: <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Pekka Enberg <penberg@kernel.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

On Fri, Apr 8, 2011 at 5:14 AM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> If someone was going to seriously go about doing something like this, a
> better approach would be to start with QEMU and remove anything non-x86 and
> all of the UI/command line/management bits and start there.
>
> There's nothing more I'd like to see than a viable alternative to QEMU but
> ignoring any of the architectural mistakes in QEMU and repeating them in a
> new project isn't going to get there.

Hey, feel free to help out! ;-)

I don't agree that a working 2500 LOC program is 'repeating the same
architectural mistakes' as QEMU. I hope you realize that we've gotten
here with just three part-time hackers working from their proverbial
basements. So what you call mistakes, we call features for the sake of
simplicity.

I also don't agree with this sentiment that unless we have SMP,
migration, yadda yadda yadda, now, it's impossible to change that in
the future. It ignores the fact that this is exactly how the Linux
kernel evolved and the fact that we're aggressively trying to keep the
code size as small and tidy as possible so that changing things is as
easy as possible.

I've looked at QEMU sources over the years and especially over the
past year and I think you might be way too familiar with its inner
workings to see how complex (even the core code) has become for
someone who isn't familiar with it. I think it has to do with lots of
indirection and code cleanliness issues (and I think that was the case
even before KVM came into the picture). So I don't agree at all that
taking QEMU as a starting point would make things any easier. (That
is, unless someone intimately familiar with QEMU does it.)

On Fri, Apr 8, 2011 at 5:14 AM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> Too much effort in QEMU goes into working around previous mistakes.  That
> doesn't mean that QEMU doesn't have a lot of useful bits in it and hasn't
> figured out a lot of good ways to do things.

Completely agreed.

                        Pekka
