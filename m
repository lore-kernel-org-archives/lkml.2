Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab0HLMrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:47:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46019 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933825Ab0HLMr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jJQWalXO+be0ZatP/JFxbfAKivgR8m5u+fDZuFVQwVJmXCDk2y9Ta6UZkAtnIYZZjD
         EGr9/D2Ezq9J6Um46rQcR68SV8aSUVLqRLEG8qPhAtDYD1sICHjjT9ZF2RkxA+OfTuID
         Hx0BmZatMAXjhOatqmEoVFNlGaX/oEhmuoJN8=
MIME-Version: 1.0
In-Reply-To: <201008121304.01178.marek.vasut@gmail.com>
References: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com>
 <AANLkTimuLjGo7O1kWXq0XbTns4EV2e5q5o0esNns1BY9@mail.gmail.com> <201008121304.01178.marek.vasut@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 12 Aug 2010 08:47:06 -0400
Message-ID: <AANLkTimuyuNGsTAfJXi7TL4HQH-botNcakse5NHj2fc0@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] ARM: Fix gen_nand probe structures contents
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, nico@fluxnic.net, kernel@wantstofly.org,
        kernel@pengutronix.de, u.kleine-koenig@pengutronix.de,
        kaloz@openwrt.org, khc@pm.waw.pl, tj@kernel.org, gregkh@suse.de,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem.Bityutskiy@nokia.com, David.Woodhouse@intel.com,
        ralf@linux-mips.org, uclinux-dist-devel@blackfin.uclinux.org,
        yakovenkov@gmail.com, w.sang@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 07:04, Marek Vasut wrote:
> Dne Čt 12. srpna 2010 05:36:31 Mike Frysinger napsal(a):
>> On Wed, Aug 11, 2010 at 22:53, Marek Vasut wrote:
>> > These three platforms didn't properly fill nr_chips in gen_nand
>> > registration and
>>
>> > therefore depended on gen_nand bug fixed by the following patch:
>> the Blackfin arch has a mailing list ... no need to pick out people
>
> Hi, that's true, but there's that "scripts/get_maintainer.pl" thing which gave
> me this list.

yes, but typically that's a shotgun approach that grabs way more
people and can easily fall out of date (people no longer
exist/etc...).  personally, i use it as a fallback when MAINTAINERS
doesnt cover it.
-mike
