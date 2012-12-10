Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2LJKy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:54:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49350 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2LJKyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:54:55 -0500
Date: Mon, 10 Dec 2012 11:54:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TIP tree's master branch failed to boot up
Message-ID: <20121210105449.GC7264@gmail.com>
References: <50C56A13.9040604@linux.vnet.ibm.com>
 <50C591B0.10408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C591B0.10408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've Cc:-ed hpa, he merged the x86/microcode bits.

Michael Wang, I've excluded x86/microcode from the latest 
version of the -tip tree which I just pushed out:

  4e00fd4c93e0 Merge branch 'x86/cleanups'

Can you confirm that your server boots now?

Thanks,

	Ingo

* Michael Wang <wangyun@linux.vnet.ibm.com> wrote:

> On 12/10/2012 12:50 PM, Michael Wang wrote:
> > Hi, Folks
> > 
> > I'm testing with the latest tip tree's master branch 3.7.0-rc8 and
> > failed to boot up my server, it's hung at very beginning and I could not
> > catch any useful log, is there any one else got this problem or I'm the
> > only one?.
> 
> And bisect catch below commit:
> 
> commit 56e7dba100a50f674627a3764fd4da4a6ec93295
> Merge: ea8432f 16544f8
> Author: Ingo Molnar <mingo@kernel.org>
> Date:   Fri Dec 7 12:13:11 2012 +0100
> 
>     Merge branch 'x86/microcode'
> 
> Regards,
> Michael Wang
> 
> 
> > 
> > Regards,
> > Michael Wang
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
