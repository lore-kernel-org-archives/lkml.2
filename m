Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2FKJU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:20:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:54043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2FKJUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:20:25 -0400
MIME-Version: 1.0
In-Reply-To: <1339404917.30984.82.camel@x61.thuisdomein>
References: <1339169631.30984.2.camel@x61.thuisdomein>
	<CALLzPKak-GLPehY84_h-wURdrfnOW1nNeML_hpwdJi7mf-XkcQ@mail.gmail.com>
	<1339404917.30984.82.camel@x61.thuisdomein>
Date: Mon, 11 Jun 2012 12:20:24 +0300
Message-ID: <CALLzPKZW73x-dun6+47_CNJkvXE=_X9HAeeYBmLtUocHOFPCBg@mail.gmail.com>
Subject: Re: [PATCH] Remove lib/mpi/generic_mpi-asm-defs.h
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 11:55 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Dmitry,
>
> On Mon, 2012-06-11 at 11:27 +0300, Kasatkin, Dmitry wrote:
>> That patch has been already reverted and unused code removed.
>> Changes are available in the #next-queue branch of Linux security tree.
>
> That would be commit 9e235dcaf4f63d88a7e9ce5735ba5c2eb2719603 ("Revert
> "crypto: GnuPG based MPI lib - additional sources (part 4)""). I'll
> remove this header from the stack of (possibly) unused headers.
>
> Thanks!
>

Yes, This patch and next one...

Thanks.

>
> Paul Bolle
>
