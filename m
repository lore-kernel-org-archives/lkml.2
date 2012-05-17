Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194Ab2EQRYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:24:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54157 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab2EQRYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:24:36 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH 0/5] Delete microchannel [CONFIG_MCA] support
Thread-Topic: [RFC/PATCH 0/5] Delete microchannel [CONFIG_MCA] support
Thread-Index: AQHNNEvq5QfBegMHnU6KIeXTVC8YWpbOsJgA
Date: Thu, 17 May 2012 17:24:33 +0000
Message-ID: <1337275472.30498.38.camel@dabdike.int.hansenpartnership.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [87.194.65.0]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D9A01D7699A4D468E654912DBF35C53@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4HHOgR8020470

On Thu, 2012-05-17 at 12:40 -0400, Paul Gortmaker wrote:
> It was good that we could support MCA machines back in the day, but
> realistically, nobody is using them anymore.  They were limited to
> 386-sx 16MHz CPU and some 486 class machines and never more than 64MB
> of RAM.

This is complete rubbish.  The MCA machines go up to 686 class with up
to 4GB of memory (admittedly, this is with the NCR MCA extensions).

>   Even the enthusiast hobbyist community seems to have dried up
> close to ten years ago, based on what you can find searching various
> websites dedicated to the relatively short lived hardware.

Well, it's used in obsolete systems, yes.  It wasn't really that short
lived, since it did penetrate quite widely for a while before EISA and
eventually PCI took over.

> So lets remove the support relating to CONFIG_MCA.  There is no point
> carrying this forward, wasting cycles doing routine maintenance on it;
> wasting allyesconfig build time on validating it, wasting I/O on
> git grep'ping over it, and so on.

So what actual problems has it had that are causing these issues.  I'm
still listed as MCA maintainer and I haven't seen any.  As far as I
thought, it was nice and cleanly separated and builds just fine for me.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
