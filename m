Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab1CWLXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:23:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34902 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab1CWLXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cSrG2ULSKBdtGf2cXMQQ7IAPXceJ6NGjpnBHbJ7dki3va25A6XyRWoIUTSsjjZ0Zo1
         GePZCYNM4amFTVydkOGmE8zX6LFtviHZyGW2dZsO9enOOBpEneSitd7YAGkKsf/799dH
         jtt0+7WOE8+7XRX/CPfz84Ry8URtvWA3I8rxI=
MIME-Version: 1.0
In-Reply-To: <AANLkTikuAr9o4fcZi15w1g0kyYehmJBi5ixJ1nmNfw_x@mail.gmail.com>
References: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
	<AANLkTikuAr9o4fcZi15w1g0kyYehmJBi5ixJ1nmNfw_x@mail.gmail.com>
Date: Wed, 23 Mar 2011 13:23:14 +0200
X-Google-Sender-Auth: oJ7OVx7uOWmAzLymwgGoSyMlUYo
Message-ID: <AANLkTimDJ05ZTLz-mW6vRWpdJSgCzSRGP_DAaSuEqz_v@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: build kmemleak-test.c as a module-only
From: Pekka Enberg <penberg@kernel.org>
To: Daniel Baluta <daniel.baluta@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Catalin Marinas <catalin.marinas@arm.com>,
        akpm@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 1:18 PM, Daniel Baluta <daniel.baluta@gmail.com> wrote:
> On Wed, Mar 16, 2011 at 8:16 PM, Daniel Baluta <dbaluta@ixiacom.com> wrote:
>> mm/kmemleak-test.c is used to provide an example of how kmemleak
>> tool works.
>>
>> Memory is leaked at module unload-time, so building the test
>> in kernel (Y) makes the leaks impossible and the test useless.
>
> Any comments on this?

Looks good to me.

Acked-by: Pekka Enberg <penberg@kernel.org>
