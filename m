Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0K2JoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:44:24 -0500
Received: from mail-gw0-f66.google.com ([74.125.83.66]:59032 "EHLO
	mail-gw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0K2JoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:44:22 -0500
X-Greylist: delayed 768 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 04:44:22 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=YcMbk0KVJTnnPvogDEXUpnkSuCC5VPdB2NF+43MdW0AspBtoXz3nkkmYw+tFXlTmIO
         ZUmAnJp5rpgK7iqiIfMOiiZejzrcLGrZXQIqoosLlvXlM0qS3lQV6Wd3zVOJ+PRbUBKg
         oCMkZqwiJkopx2pH3diUy4ewRnRx2/KVBneSw=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <20101129085829.GM5142@const.bordeaux.inria.fr>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <20101129020610.7ea7c79e.lisa@ltmnet.com>
	 <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org>
	 <1290993244.877.3.camel@cai.gentoo>
	 <20101129085829.GM5142@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 17:32:37 +0800
Message-ID: <1291023157.9785.2.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-29一的 09:58 +0100，Samuel Thibault写道：
> Microcai, le Mon 29 Nov 2010 09:14:04 +0800, a écrit :
> > Hey, my old patch already did it , and do not break any old stuff.
> 
> To your knowledge.  IIRC while reading your patch I found a couple of
> things that would most probably break some corner cases, which could
> go unnoticed, that's why I proposed to first extend the internal vc
> content matrix into unicode values, so as to clearly have to upgrade all
> drivers.
> 
> Samuel

I doesn't matter *how to do* . I have many different kinds of patchs
that did it in different ways.

What realy matters is that, do we agree that add unicode font support is
acceptable ?



