Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0FCNix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:38:53 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:64983 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0FCNiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:38:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RrBtpg1kSb8as1yTEnxV3SRKFdPwaRfFIhj63ljEvC722dMs/NvM/goBrOdqdwBwcO
         ACEos6MEUFC7xuqhF7iaARltLj+yWq07XOxzywGpmZTPqOUnT22Dty4uc3W+4cHS7MuJ
         jYeja6yRrLr0GSVxrAWmIbDLPnECwwdqyh2vw=
MIME-Version: 1.0
In-Reply-To: <20100603131414.GA23520@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
	<20100603075402.GA11093@oksana.dev.rtsoft.ru>
	<AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
	<20100603084104.GA17431@oksana.dev.rtsoft.ru>
	<AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
	<AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
	<20100603093923.GA25856@oksana.dev.rtsoft.ru>
	<AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com>
	<20100603131414.GA23520@oksana.dev.rtsoft.ru>
Date: Thu, 3 Jun 2010 21:38:50 +0800
Message-ID: <AANLkTinerNNyas_jt3tn68EJMNTDGm15KN54AcptKNLb@mail.gmail.com>
Subject: Re: 2.6.25-rc1 ahci regression
From: Luming Yu <luming.yu@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Meanwhile, here is a guess: initrd isn't happy about
> the new libahci.ko dependency for ahci.ko, and so it
> doesn't load the module? Why? I don't know. Let
> me check it...
>

ah, your no function changed code creates a new module libahci
and it's not in initrd? so I have this problem, a good guess I think
I will check it
