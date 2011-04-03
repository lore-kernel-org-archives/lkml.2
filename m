Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1DCIxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 04:53:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49622 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1DCIxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 04:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=l8DgDtTPzQ6ooOBMNRMTmMkhTNkmDopmOzmCjaaVGmyiiH0Y74wOYhE49daB6W5s6Q
         NIsWWCe8n14BWEbdOTM9tBhWbr8wD70w/5WgqxNHE5NQpWNE2UbKtxL7O6VDdz87Yv5l
         /qkSMdUcfqYND3XY20UolvLIZbIVALf8EAIoM=
MIME-Version: 1.0
In-Reply-To: <4D982EB8.7080001@redhat.com>
References: <1301592656.586.15.camel@jaguar>
	<4D978930.1000909@codemonkey.ws>
	<20110403062117.GA27121@elte.hu>
	<4D982EB8.7080001@redhat.com>
Date: Sun, 3 Apr 2011 11:53:34 +0300
X-Google-Sender-Auth: PfTnLCTseBTd4MVVbNs3QblZ3DU
Message-ID: <BANLkTikkyktU3KL8h71PYLF_ds0C07QKcg@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Apr 3, 2011 at 11:24 AM, Avi Kivity <avi@redhat.com> wrote:
> On 04/03/2011 09:21 AM, Ingo Molnar wrote:
>>
>> * Anthony Liguori<anthony@codemonkey.ws>  wrote:
>>
>> >  On 03/31/2011 12:30 PM, Pekka Enberg wrote:
>> >  >  Hi all,
>> >  >
>> >  >  We’re proud to announce the native Linux KVM tool!
>> >
>> >  Neat!
>> >
>> >  As something of a lesson of history, I'd suggest picking a more unique
>> > name
>> >  while it's still a prototype :-)
>>
>> I disagree, i find it pretty handy and intuitive to run 'kvm ./disk.img'
>> to
>> boot KVM and this particular tool name has not been taken yet either.
>
> Some distributions install qemu-kvm as /usr/bin/kvm.
>
>> perf uses a similar concept: the kernel subsystem is generally called
>> 'perf',
>> and the (Linux specific) user-space tool is called 'perf' as well. It
>> makes
>> quite a bit of sense.
>
> Well, this is bound to cause confusion as the tool is yet quite immature.

Yes, that's really unfortunate. I don't care too much what we call the
tool but I definitely agree with Ingo that 'kvm' is more discoverable
to users. Any suggestions?

                        Pekka
