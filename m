Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0JKVBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:01:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45701 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab0JKVBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WleZsYfIpn7aIT2T4KbSB8VApO1uwggz6TeSZDiGq1yubxDPdWkym/5xzOG53z7PGZ
         07jSRiKE9KxyGQ3Hpyz+oNjq1qjYW2yn8x8KB5rpCeYT/+vMdJDNGJRzUEjtdqWHtYEQ
         f3lfZrRbA09GnaRwEwnSNuSD0j6W+4vI/NbJ0=
MIME-Version: 1.0
In-Reply-To: <1286811979.9645.5.camel@ayu>
References: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
	<1286811979.9645.5.camel@ayu>
Date: Tue, 12 Oct 2010 00:01:35 +0300
Message-ID: <AANLkTinaJU_=MuCcefOweED5g2HMpHjUra8nR6mBdoyR@mail.gmail.com>
Subject: Re: Horrible btrfs performance on cold cache
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Calvin Walton <calvin.walton@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 6:46 PM, Calvin Walton <calvin.walton@gmail.com> wrote:
> On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
>> I use btrfs on most of my volumes on my laptop, and I've always felt
>> booting was very slow, but definitely sure is slow, is starting up
>> Google Chrome:
>>
>> encrypted ext4: ~20s
>> btrfs: ~2:11s
>>
>> I have tried different things to find out exactly what is the issue,
>> but haven't quite found it yet.
>
> If you've been using this volume for a while, it could just have become
> badly fragmented. You could try btrfs's fancy online defragmentation
> abilities to see if that'll give you an improvement:
>
> # btrfs filesystem defragment /mountpoint/of/volume
>
> Let us know if that helps, of course :)

~2:06s, so it helped a bit, but not much really, there's still
something fishy going on.

-- 
Felipe Contreras
