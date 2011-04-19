Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1DSNtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:49:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36677 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1DSNtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=C8pe0IE1AcvfCw+t6PS0blbjS/rpTzo5y0mT8ih2fLHqmLEiLOC+qD0AVRzXxDzDsi
         NWkw4XJQHEZhTdC4h956L7/zuETvt945kxr0PTg9U6F0hcK3QoTV96GmmXC1nFmGoGtD
         9HlOtgWvteh1+R/Eiy3kHuw1tZML2cxcD+iGM=
MIME-Version: 1.0
In-Reply-To: <BANLkTinX7cknxL619o6R=0foeQMpTbRK-Q@mail.gmail.com>
References: <BANLkTinX7cknxL619o6R=0foeQMpTbRK-Q@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 19 Apr 2011 19:19:04 +0530
X-Google-Sender-Auth: v-OMYWCxWuqsVN_H2TLzi-heFUM
Message-ID: <BANLkTin6dXxj-HVMhR_KJzWjHdO8cb=3JQ@mail.gmail.com>
Subject: Re: How to mount filesystem from RAM ?
To: Jongman Heo <jongman.heo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:32, Jongman Heo <jongman.heo@gmail.com> wrote:
> Instead, I can load the data from the partition into RAM, which means
> whole filesystem data is copied into some location of RAM. ( I know
> the physical address, for the data to be loaded.) This copy operation
> is done by bootloader side, not in Linux.
>
> In this case, how can I mount the filesystem from RAM? Is there any
> way to do this?

Have a look at slram or phram in drivers/mtd/devices/.

> And I think the memory location of filesystem data should be reserved
> not to be used by Linux kernel and user space application, am I right?

One way to do this is by passing appropriate mem= arguments.
