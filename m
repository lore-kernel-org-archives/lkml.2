Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0K1QTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 11:19:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41425 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0K1QTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 11:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=M8mwwokDVwASIk+CxIzQU1G/8sd4+lk8rqrxwRGyzzJtP/hYL5iL/dH3r/SyAb/uro
         Eeai10PT7nRo+zyc8rzjh3Y5OAjdFTaou13QFM9pRajYAyYOVTc1yaRa8J0k1GHysfHz
         ATt5vLVwHG+BinwcWzrZDJTkk4uPhjz18n77I=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Lisa Milne <lisa@ltmnet.com>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>, Theodore Tso <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <20101129020610.7ea7c79e.lisa@ltmnet.com>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <20101129020610.7ea7c79e.lisa@ltmnet.com>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 00:20:07 +0800
Message-ID: <1290961207.13526.31.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Another possible model: split the current system in 2, so there's a
> bytestream handler, and a vt-legacy module. Then use the interface
> between bytestream/legacy as an interface for future vt-kernel and
> vt-user modules.

this may cause early printk stop working. 

> 
> This may make it possible to create an initial patch to do the split,
> then work on the new system independently of the current vt system.
> Hopefully reducing any problems with api/subsystem inconsistencies
> breaking existing code elsewhere, by giving it time to adapt.
> 
> This is guesswork on my part as I haven't actually looked at the code,
> so while it sounds good in theory, you'd have to check if it's actually
> doable.
> 

Sounds like a good idea. Who is in charge of VT system ? Seems no
one ....

