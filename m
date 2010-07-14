Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab0GNTcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:32:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58357 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0GNTcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vejq93iNUd/4CQKAr8Qkg1hpjQMUgfNjR1A0vdu8HHoP+d1SREsPbv2+2OK1c8NJFw
         91NbUqKL/xCFBbtQO+SqXvOe/MwPJb+e3aubg/Nfh0v8tHiwloFqHgh/Yg7RdwImFbQf
         H3HJKv2OA+JDP+XvKWPYK2Z+NX7dIccHJ3B4c=
MIME-Version: 1.0
In-Reply-To: <4C3E096B.8050505@zytor.com>
References: <20100707124731.GJ15122@anguilla.noreply.org>
	<4C359D5A.1050906@redhat.com>
	<20100713102350.GW15122@anguilla.noreply.org>
	<4C3C68C8.4060409@redhat.com>
	<20100713141902.GB15122@anguilla.noreply.org>
	<4C3C8CE5.1080705@redhat.com>
	<20100713162207.GC15122@anguilla.noreply.org>
	<4C3C9589.4090602@redhat.com>
	<4C3C96EC.8060901@redhat.com>
	<4C3C9839.4090404@redhat.com>
	<20100713172526.GE15122@anguilla.noreply.org>
	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>
	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>
	<4C3CAE8F.10900@goop.org>
	<4C3CE560.5050701@zytor.com>
	<4C3CFB8B.1090804@goop.org>
	<AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com>
	<4C3DF1BE.2070404@goop.org>
	<4C3DF447.1000801@zytor.com>
	<4C3DF519.6030406@goop.org>
	<4C3DF7AF.7010402@zytor.com>
	<4C3DFA88.5020007@goop.org>
	<4C3DFD12.3050700@zytor.com>
	<AANLkTikA8SO42kOgHZb-6YuhM7GPnmg81IAX5vEk_Cqk@mail.gmail.com>
	<4C3E096B.8050505@zytor.com>
Date: Wed, 14 Jul 2010 12:32:42 -0700
Message-ID: <AANLkTil5uvr9sWc_o3HmOsJ0iaJJjaMkkrMwF0BsEdHg@mail.gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point 
	for pvclock
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 12:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/14/2010 11:18 AM, H.J. Lu wrote:
>>
>> There are some discussions on:
>>
>> http://gcc.gnu.org/ml/gcc-patches/2010-06/msg02001.html
>> http://gcc.gnu.org/ml/gcc-patches/2010-07/msg00001.html
>>
>> Are they related?
>>
>
> Not directly as far as I can tell.
>
> The issue is if gcc can ever reorder, duplicate or elide a volatile
> operation (either asm volatile or a volatile-annotated memory
> reference.)  In my (and Linus') opinion, this would be an incredibly
> serious bug.
>
>

Is there a gcc bug for this?



-- 
H.J.
