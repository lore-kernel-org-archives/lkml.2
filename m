Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab0HCXNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 19:13:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45678 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0HCXNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 19:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTik4DRO3685HG8-Hkp3=s=vinUdTQ=votQuf4-8N@mail.gmail.com>
References: <AANLkTin3+LfXOpW5MsPSgs_5Z0UFnQTwBAXSocrU1Xs8@mail.gmail.com> 
	<1280871336-31046-2-git-send-email-wad@chromium.org> <AANLkTimX-5v4qNeK1DD84n8z6-jpq8DSvCa5PepuhgM5@mail.gmail.com> 
	<AANLkTik4DRO3685HG8-Hkp3=s=vinUdTQ=votQuf4-8N@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 4 Aug 2010 01:13:19 +0200
Message-ID: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
Subject: Re: [PATCH 2/2] genhd, efi: add efi partition metadata to hd_structs
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 00:27, Will Drewry <wad@chromium.org> wrote:
> On Tue, Aug 3, 2010 at 4:54 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:

>> Did you already test to put a lookup-call to the in-kernel mounter, if
>> we use some special partition table uuid identifier for root=? That
>> would be nice to see, if all that works as expected, and we can get to
>> the data we collect.
>
> Not yet, but I'd like to have it working there (and in my
> device-mapper target) as soon as possible.  Hopefully, I'll have that
> done pretty soon and I'll repost the series inclusive of an init:
> change.

Nice.

> Any preferences on the variable? I'll start with your example of
> PARTUUID=, but that follows the initramfs model (UUID=) and not the
> existing magic root devices (/dev/nfs, /dev/ram).
> /dev/by-part-uuid/XXX... doesn't seem super-friendly though :)

Yeah, this stuff does not really fit in to the path notation stuff,
unless we use the udev-style link names, which some people like to
avoid, and prefer some more abstract thing here.

We have UUID=, LABEL= for mount and fstab, I think PARTUUID=,
PARTLABEL= matches this.

We can always change that, if something better comes up before this
gets official. :)

Kay
