Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab1BWUGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:06:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35485 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab1BWUGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:06:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WAW9/DJVbNpq3QPNnfYspkVbXX3JE+5ui9/o7bBeaVS30oo0gl4SEyF01Pe02LJ1st
         oGDIwGNeA07qnDcHNMRenrI+iC3pbPayRB6C0KMhJgPDfz7chYEd/ZBePd0d1rO5QV3H
         vuT2B+DtG0biearQwZv0LDasBgnK08z5dynfE=
MIME-Version: 1.0
In-Reply-To: <20110223115414.547b8c17@queued.net>
References: <20110216222820.487AE9D401C@zog.reactivated.net>
	<1297896277.3011.5.camel@macbook.infradead.org>
	<AANLkTikAF2X1A5jfoNfCPRhZkZ7qPdZ57c8B5b9z4+qr@mail.gmail.com>
	<20110218190659.7f955e4c@queued.net>
	<20110223194352.GR14597@angua.secretlab.ca>
	<20110223115414.547b8c17@queued.net>
Date: Wed, 23 Feb 2011 20:06:47 +0000
X-Google-Sender-Auth: 5q1jaDO9oH74lfaZMNlyNkqWAiE
Message-ID: <AANLkTi=D1eWGsN4JVWEGeHp3AXfpbOOKr9Fq7juGAXtT@mail.gmail.com>
Subject: Re: [PATCH] of/pdt: allow DT device matching by fixing 'name' brokenness
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Woodhouse <dwmw2@infradead.org>, cbou@mail.ru,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, dmitry.torokhov@gmail.com,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 February 2011 19:54, Andres Salomon <dilinger@queued.net> wrote:
>> Wait; why are you binding to a device based on name?  Binding by name
>> and/or device_type is strongly discouraged for new code.  Use
>> compatible instead.
>>
>
> Daniel posted a separate patch showing his code, would you mind
> commenting on that?  I noticed he didn't cc you though, here's the
> patch:
>
> https://patchwork.kernel.org/patch/574901/

It does bind to the name.
We don't currently have a compatible property for the battery device.
We could fix that with a firmware upgrade, but it would break
compatibility with all existing installs. I guess this is still the
recommended approach...

Daniel
