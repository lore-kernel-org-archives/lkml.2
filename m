Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2JIGVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:21:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35019 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2JIGVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <5073BF32.7040003@zytor.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
	<5073BF32.7040003@zytor.com>
Date: Mon, 8 Oct 2012 23:21:15 -0700
X-Google-Sender-Auth: fUEld2Dfy5XS_OaMGHGR1vyZ5xo
Message-ID: <CAE9FiQWUg0wmMLANmshxob3ftxa2xY9mUSivzsWCGkJ2_==_Qg@mail.gmail.com>
Subject: Re: [PATCH -v2 00/10] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 11:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/09/2012 12:39 PM, Yinghai Lu wrote:
>> on top of tip/x86/mm2
>
> Hi Yinghai,
>
> This patchset doesn't apply on top of tip:x86/mm2, starting at patch 08/10.

sorry for that. I refresh my base to current linus/master and tip/master.

could be some change there.

could solve it:
1. update x86/mm2 to linus/master
2. or i resend the patch again with x86/mm2 as base.

please let me know which one you like.

>
> Furthermore, a lot of the descriptions are both incomplete and
> incomprehensible, which makes the patchset very very hard to review.
>
> You should think of the descriptions as writing a (short) paper on your
> patchset, where you describe not just what you are doing, but how you
> accomplish the objective and why that objective is the right thing do
> accomplish.

Actually I spent a while on the changelog of this patchset.

will spend more time for next reversion.

>
> Overall, this patchset seems to be going in the right direction, but I
> have several concerns with details.

good, will update the patches accordingly.

Thanks

Yinghai
