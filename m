Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2AQJsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:48:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:27480 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2AQJsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:48:45 -0500
MIME-Version: 1.0
In-Reply-To: <4F10B2EC.1010906@xenotime.net>
References: <20120113155808.05431d23da358e37b19eee7c@canb.auug.org.au>
	<4F10B2EC.1010906@xenotime.net>
Date: Tue, 17 Jan 2012 11:48:44 +0200
Message-ID: <CALLzPKbnjLmbV2WAiN85LOWC16kH1TZkwQQtgz+6PJDac56-AQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 13 (lib/digsig.c)
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 12:40 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 01/12/2012 08:58 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20120112:
>
>
> ERROR: "crypto_alloc_shash" [lib/digsig.ko] undefined!
> ERROR: "crypto_shash_final" [lib/digsig.ko] undefined!
> ERROR: "crypto_shash_update" [lib/digsig.ko] undefined!
> ERROR: "crypto_destroy_tfm" [lib/digsig.ko] undefined!
>
Hi,

I have done a fix and sent it to linux-security-modules mailing list...

[PATCH 2/4] lib: digital signature dependency fix

Thanks,
Dmitry


>
> Full randconfig file is attached.
>
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
