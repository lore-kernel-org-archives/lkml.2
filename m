Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab0JSVkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:40:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48457 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab0JSVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=BDysl4lW6ya4KScxiGXy7tnr0l369HmHdytDkQNmrXSKpujcDtX3BuIQqCi+A1eFCL
         neu3V62eVc75G6UIJiRRg+j973FOfVrjtFxrf0618L68Bmg/ykRLVMo6KTRsGZexHUsx
         /9Cqx/YrStqNT5ew54QsOPFUdb1FEATss6+8o=
MIME-Version: 1.0
In-Reply-To: <20101019213112.GA11432@merkur.ravnborg.org>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com>
 <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
 <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
 <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
 <20101019213112.GA11432@merkur.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 19 Oct 2010 17:39:39 -0400
Message-ID: <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 17:31, Sam Ravnborg wrote:
> Another way to fix this would be to fix asm-generic/vmlinx.lds.h
> to check for CONFIG_SYMBOL_PREFIX direct.
> I cannot see why we require the SYMBOL_PREFIX definition.

because CONFIG_SYMBOL_PREFIX is "_" when we need it to be _ and the
cpp has no way of removing quotes
-mike
