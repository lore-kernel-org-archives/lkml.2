Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0DHFpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:45:10 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:50626 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab0DHFpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HfDv7hBLvGy3SAg7mPkFG7ThOqgoKeCNOILWQuQcJ4oZKzRip0VbIfHptrAlcvhGyt
         5O0PcSWiuqUbwhwoZJFx/OTrY/OMOJVk3XoSI1/fBR5H8EnQwBmhw6FP1psEP5+F/ajK
         WBJ6tLuWINS1Wa+HlaoKKVp6Vdd0dvAIEOa/w=
MIME-Version: 1.0
In-Reply-To: <20100408.113405.221629738.ryusuke@osrg.net>
References: <20100405173402.GA22644@xhl> <20100405173534.GB22644@xhl>
	 <20100407142058.GA27224@xhl>
	 <20100408.113405.221629738.ryusuke@osrg.net>
Date: Thu, 8 Apr 2010 13:45:05 +0800
Message-ID: <u2p3a3680031004072245t5ea476a5xbd6cbe6d3302de00@mail.gmail.com>
Subject: Re: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
From: Li Hong <lihong.hi@gmail.com>
To: Ryusuke Konishi <ryusuke@osrg.net>
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/8 Ryusuke Konishi <ryusuke@osrg.net>:
> On Wed, 7 Apr 2010 22:20:58 +0800, Li Hong <lihong.hi@gmail.com> wrote:
>> Hi KONISHI Ryusuke,
>>
>> Any feedbacks on these patches?
>>
>> Thanks,
>> Li Hong
>
> Well, adding a load message is ok, but it should be more moderate like
> "nilfs2 file system loaded\n".
Yes. I just thought that printing a message after loading a file
system is a practice.
You may choose any string that you think is suitable :)

> I think this sort of change should be discussed in the sub topic
> mailing list (i.e. linux-nilfs).  You don't have to cc every patch to
> linux-kernel.
Ok. No problem.

> And, please include some explanation in the change log to clarify the
> aim or motivation.
I took it as a very simple patch and thought a header was enough. I can add more
explanations if here has a demand.

> Thanks,
> Ryusuke Konishi
>

Thanks very much,
Li Hong
