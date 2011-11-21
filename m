Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab1KUKUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:20:38 -0500
Received: from mga07.intel.com ([143.182.124.22]:49518 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755421Ab1KUKUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:20:35 -0500
MIME-Version: 1.0
In-Reply-To: <20111119143337.cd84cfc59a78e0378dbd4089@canb.auug.org.au>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
	<fad5214d102c09d2a2bf971483efb6e0dbee3937.1319025009.git.dmitry.kasatkin@intel.com>
	<20111119143337.cd84cfc59a78e0378dbd4089@canb.auug.org.au>
Date: Mon, 21 Nov 2011 12:20:33 +0200
Message-ID: <CALLzPKZ70YWb45k+8Z6ApH5MuN7HwBBTWbLcu-UtRkFU07cwmg@mail.gmail.com>
Subject: Re: [PATCH v2.2 1/7] crypto: GnuPG based MPI lib - source files (part 1)
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, herbert@gondor.hengli.com.au,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 5:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> On Wed, 19 Oct 2011 14:51:30 +0300 Dmitry Kasatkin <dmitry.kasatkin@intel.com> wrote:
>>
>> Adds the multi-precision-integer maths library which was originally taken
>> from GnuPG and ported to the kernel by (among others) David Howells.
>> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
>> The difference is that checkpatch reported errors and warnings have been fixed.
>>
>> This library is used to implemenet RSA digital signature verification
>> used in IMA/EVM integrity protection subsystem.
>>
>> Due to patch size limitation, the patch is divided into 4 parts.
>
> I just noticed that this has been added to the "next" branch of the
> security tree (and thus into the next release of linux-next).  I think
> that these patches should be rearranged as in their current form, they
> break bisection (since the files in this patch reference include files in
> a latter patch).   We generally prefer large patches to be broken up into
> logical sub patches rather than just along file boundaries.
>
> In this case, even though it was broken up for review, it could have been
> committed as one large commit (assuming that there is no sensible way to
> break it up).

Hi,

It can be easily split into 2 commits and one of them would not comply
with mailing list limits.

James, should I do anything about it?

Thanks,

- Dmitry

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
