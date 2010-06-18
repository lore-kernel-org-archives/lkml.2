Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab0FREQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:16:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42891 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0FREQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=a8ghwOnfNz+Mf2nYgItGGiPjxTw6EmDtxkm4VElBes78OR4D90TxeRjCpl1Ou77mE/
         X7BCGx7DTCMvPgwno2pminUd9MywadAgn4Us6raVJDWkQJp0yt00xfp8TRJvA1XjSs8h
         wI+qYARk1WjafUYgt93YdwymOIEtQ0x5SByhM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinXqVqe9xWQYj-CyzPHl9k7qAqxX6ueOqB3qTve@mail.gmail.com>
References: <AANLkTinXqVqe9xWQYj-CyzPHl9k7qAqxX6ueOqB3qTve@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 18 Jun 2010 12:15:45 +0800
Message-ID: <AANLkTimmvPMG0GFEXfgFlXgC7V4dIWmW8vEC5gegsKSE@mail.gmail.com>
Subject: Re: [Question] SuspendToDisk Feature on ARM ?
To: sumeet linux <sumeet4linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:08 PM, sumeet linux <sumeet4linux@gmail.com> wrote:
> Hi List,
>
> Does there exists a support for Suspend To Disk (Hibernate) for ARM
> platforms?
> I have been googling for it but could not find any information other than
> some links to the suspend2 support for some ancient kernels.
> Can anyone provide any clue on how much effort is required to implement this
> feature to ARM architecture ?
>

Marvell has done a great job on this for a preliminary enabling on their Dove
processor, please have a look into:

http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-lucid.git;a=shortlog;h=refs/heads/mvl-dove

arch/arm/mach-dove/swsusp.S

The code, mostly, is generic enough to be made common if you are
interested and have other platforms (with HDD or large NAND) to
test. x86 is, of course, the reference.
