Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1HDHAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:00:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64965 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1HDHAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:00:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110804163629.e866b8f3052b7ac34dc83912@canb.auug.org.au>
References: <20110804142858.f7f2f128e5a038beb20aa87b@canb.auug.org.au> <20110804163629.e866b8f3052b7ac34dc83912@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 4 Aug 2011 07:59:56 +0100
X-Google-Sender-Auth: ncSzGyKrt6JYA3uW2ERiMF3UZuU
Message-ID: <CACxGe6ss62FFwQOk49dHqEN_35iVTSz0bFg4eH1T_iSeipiJaw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Linus <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 7:36 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi All,
>
> On Thu, 4 Aug 2011 14:28:58 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the final tree, today's linux-next build (sparc64 defconfig)
>> failed like this:
>>
>> drivers/built-in.o: In function `of_alias_scan':
>> (.init.text+0x6074): undefined reference to `early_init_dt_alloc_memory_arch'
>>
>> Caused by commit 750f463a749e ("dt: add of_alias_scan and of_alias_get_id").
>>
>> I have reverted that patch for today.
>
> And that commit has now gone into Linus' tree :-(

Pull my tree now; there is a fix in there.  I'm just emailing it now.

g.
