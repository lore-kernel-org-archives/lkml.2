Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1HZPrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:47:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56398 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab1HZPrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:47:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110826103932.1626f1c5542b660bcd1b24aa@canb.auug.org.au>
References: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
	<20110825140820.GA9126@kroah.com>
	<4E56689D.3080202@freescale.com>
	<20110826015111.49af16f792d5554fd931d230@canb.auug.org.au>
	<CACqU3MUs_97=MuuKAjr-LeUT7kSRxtzSntwUeKeeH4n8s7SSGg@mail.gmail.com>
	<20110826103932.1626f1c5542b660bcd1b24aa@canb.auug.org.au>
Date: Fri, 26 Aug 2011 11:47:40 -0400
Message-ID: <CACqU3MVbKJw5VVqnz+gfLDnQEDu9Lv4xV+7RvdD4ZbetGu79WQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty tree related)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Removed PPC folks from the CC list, the conversation drifted.]

On Thu, Aug 25, 2011 at 8:39 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Arnaud,
>
> On Thu, 25 Aug 2011 12:09:20 -0400 Arnaud Lacombe <lacombar@gmail.com> wrote:
>>
>> If you could provide an exhaustive list of them, I'd be interested. Do
>> you account/reference them in the report you make on each new -next
>> tree ?
>
> I don't refer to them at all :-(
>
> If you are not just referring to powerpc ones, then an x86_64
> allmodconfig is a good place to start, there are several in there.
>
> Otherwise, I will send you the results of some of my builds this evening.
>
Couldn't all the error log be public, rotated over a 7 iteration
period ? That would be fair to everyone.

Thanks,
 - Arnaud
