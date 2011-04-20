Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1DTBFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:05:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62254 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1DTBFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Gb1deFweivbxPyUmVB0YAKOrgTgMdqgr4Mkhw0BuRnwlOAhdp7f2+kOdhf7NHOqov5
         WjcuWGYdlxjvWs06Ld1X0CjuJD0szXpsF7kVUNDRjMUZOAln/Dyxd+LqhOxURHl8A7ho
         Uell5fWvPZ+z2+O7ayXeCk3ZgfuXDwkY7yLNc=
MIME-Version: 1.0
In-Reply-To: <BANLkTin6dXxj-HVMhR_KJzWjHdO8cb=3JQ@mail.gmail.com>
References: <BANLkTinX7cknxL619o6R=0foeQMpTbRK-Q@mail.gmail.com>
	<BANLkTin6dXxj-HVMhR_KJzWjHdO8cb=3JQ@mail.gmail.com>
Date: Wed, 20 Apr 2011 10:05:30 +0900
Message-ID: <BANLkTimxPS26Chnb+VCPZKPnbHY=0d_7uw@mail.gmail.com>
Subject: Re: How to mount filesystem from RAM ?
From: Jongman Heo <jongman.heo@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/19 Rabin Vincent <rabin@rab.in>:
> On Tue, Apr 19, 2011 at 11:32, Jongman Heo <jongman.heo@gmail.com> wrote:
>> Instead, I can load the data from the partition into RAM, which means
>> whole filesystem data is copied into some location of RAM. ( I know
>> the physical address, for the data to be loaded.) This copy operation
>> is done by bootloader side, not in Linux.
>>
>> In this case, how can I mount the filesystem from RAM? Is there any
>> way to do this?
>
> Have a look at slram or phram in drivers/mtd/devices/.
>
>> And I think the memory location of filesystem data should be reserved
>> not to be used by Linux kernel and user space application, am I right?
>
> One way to do this is by passing appropriate mem= arguments.
>

Hi, Rabin.

I think that is what I've been looking for. I'll try phram.

Thanks and regards,
Jongman.
