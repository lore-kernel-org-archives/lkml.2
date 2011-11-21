Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1KUPc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:32:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:53234 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1KUPc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:32:56 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1111212227130.20158@tundra.namei.org>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
	<fad5214d102c09d2a2bf971483efb6e0dbee3937.1319025009.git.dmitry.kasatkin@intel.com>
	<20111119143337.cd84cfc59a78e0378dbd4089@canb.auug.org.au>
	<CALLzPKZ70YWb45k+8Z6ApH5MuN7HwBBTWbLcu-UtRkFU07cwmg@mail.gmail.com>
	<alpine.LRH.2.00.1111212227130.20158@tundra.namei.org>
Date: Mon, 21 Nov 2011 17:32:54 +0200
Message-ID: <CALLzPKa9dAKTWTsFJg5SUDM0LkywDMOc0AYpYvv_tfsYF2wHDA@mail.gmail.com>
Subject: Re: [PATCH v2.2 1/7] crypto: GnuPG based MPI lib - source files (part 1)
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: James Morris <jmorris@namei.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, herbert@gondor.hengli.com.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 1:27 PM, James Morris <jmorris@namei.org> wrote:
> On Mon, 21 Nov 2011, Kasatkin, Dmitry wrote:
>
>> It can be easily split into 2 commits and one of them would not comply
>> with mailing list limits.
>>
>> James, should I do anything about it?
>
> No, it's in my public tree now.
>

Ok.

In fact it does not break bisect, because compilation is enabled in
the 3rd patch.

BR,
Dmitry

>
> - James
> --
> James Morris
> <jmorris@namei.org>
>
