Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1AVJeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 04:34:09 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59142 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1AVJeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 04:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=p0Rk6DbVtnF4KgnDIiu9xaAPEes5k69LD2En+du1d5hpaeuoNZ2vjt2OzQCFfW3TsZ
         yjkwZZAz5oorA06z/3/jhCmqtc/XnQSDkjLvSzT00i3Eh6SyD3FaJdOUA+diGpFcq6/x
         MbsC5tStXa2v3/D77wnXMPbaVIdI1aZPzg9/4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110122120941.20aec5de.sfr@canb.auug.org.au>
References: <20110121164501.GB29131@dumpdata.com>
	<20110122120941.20aec5de.sfr@canb.auug.org.au>
Date: Sat, 22 Jan 2011 10:34:03 +0100
Message-ID: <AANLkTi=0g9BOKbtMKFK-gaNojmj7AZhTaqoyhnELVySn@mail.gmail.com>
Subject: Re: Change name from swiotlb-xen to xen-two tree and branches.
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 2:09 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Konrad,
>
> On Fri, 21 Jan 2011 11:45:01 -0500 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
[...]
>> Would you be OK changing the name from swiotlb-xen to 'xen-two' and
>> pulling from #linux-next branch instead of #master please?
>
> All done - but my next tree will not be built until Jan 31 ...
>

It would be great to have a linux-next based on 2.6.38-rc2 before LCA-2011.
The only conflict I had to solve was in "arch/x86/xen/p2m.c" (for
details see [1]).

- Sedat -

[1] "xen: p2m: correctly initialize partial p2m leaf"
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b
