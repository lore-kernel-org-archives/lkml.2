Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0IERll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 13:41:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40941 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab0IERlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 13:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IUryYE01+ikheo2KYctNOp9uO32bPZWQWmWqhFpfn3/ZsLtO6mbwS3k1SDotNts7SD
         kHp6gW8xiFGrql2GeNU8ZMS7Udjo401m0gPdKDVvARYO/QelcGicMENOxSH3DI8k5NSa
         W4BAr/yNtyaIuZK/rRO6HirLeB1TBBb9b5ykk=
MIME-Version: 1.0
In-Reply-To: <20100905122734.GA25532@sucs.org>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
	<alpine.LSU.2.00.1009041244440.3044@sister.anvils>
	<87vd6ls0jd.fsf@turtle.gmx.de>
	<20100904224453.GA31664@sucs.org>
	<AANLkTin63=Eyyk_dwmKtPvP_qPyKR2eDn-2FmmvGjTQu@mail.gmail.com>
	<20100905091451.GA23589@sucs.org>
	<AANLkTi=rcFZff22TMX+vfQj=5jQunmiC2UvEhZoheeTd@mail.gmail.com>
	<AANLkTimkv-DgWYfD8GOj1bsEvFJfY+-g06uz=WDC37PC@mail.gmail.com>
	<20100905122734.GA25532@sucs.org>
Date: Sun, 5 Sep 2010 19:41:38 +0200
Message-ID: <AANLkTi=6AAPNYaUVDjXDoFwrkNhB3wWnbZxR48u03ufk@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Sven Joachim <svenjoac@gmx.de>, Hugh Dickins <hughd@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Sep 5, 2010 at 2:27 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Hi,
>
> On Sun, Sep 05, 2010 at 12:21:33PM +0200, Fabio Comolli wrote:
>>
>> > Never had this kind of issues. I also tested rc2 without problems.
>
> Hmm I'm at a loss to explain what I'm seeing (and why you aren't). For
> what it's worth, I'm including my current kernel config below (no
> modules so you will have to use root=/dev/foo to tell it the initial
> device). Can you build a kernel with it and report back what you see?:
>
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.36-rc3
> # Sun Sep  5 13:14:12 2010
> #

<snip the whole config>

Well, actually I can't because your config is too different from mine.
Not only I use btrfs as the root filesystem; the main difference is
that my root and home partitions are on two dm-crypt volumes.

I see that the patch has been applied, so when it reaches mainline I
will test and report back.

Regards,
Fabio
