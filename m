Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0HDP0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:26:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55294 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0HDP0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimsSJSGLrwbJ05F9dqvvB2GxpE5a+T4J4pTGH6r@mail.gmail.com>
References: <AANLkTin3+LfXOpW5MsPSgs_5Z0UFnQTwBAXSocrU1Xs8@mail.gmail.com> 
	<1280871336-31046-2-git-send-email-wad@chromium.org> <AANLkTimX-5v4qNeK1DD84n8z6-jpq8DSvCa5PepuhgM5@mail.gmail.com> 
	<AANLkTik4DRO3685HG8-Hkp3=s=vinUdTQ=votQuf4-8N@mail.gmail.com> 
	<AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com> 
	<19545.30920.745148.710816@stoffel.org> <AANLkTimsSJSGLrwbJ05F9dqvvB2GxpE5a+T4J4pTGH6r@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 4 Aug 2010 17:25:46 +0200
Message-ID: <AANLkTi=tyZe6YVmvbSgG+BvPBqV6FwwgpYMZ8zczyPVc@mail.gmail.com>
Subject: Re: [PATCH 2/2] genhd, efi: add efi partition metadata to hd_structs
To: Will Drewry <wad@chromium.org>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 16:45, Will Drewry <wad@chromium.org> wrote:
> On Wed, Aug 4, 2010 at 9:27 AM, John Stoffel <john@stoffel.org> wrote:

>> Ugh, why do we care whether a UUID refers to a disk or a partition?

Because it is not a filesystem UUID, and that matters to distinguish.
You can even reformat the partition and it stays the same.

>> It should be unique no matter what, so just do /dev/uuid/XXXX and call
>> it done.
>
> Since these are supposed to be _unique_ it seems that any reference to
> a uuid should be fair game.  And if a root=/dev/uuid/XXX makes it to
> an initramfs environment, then that'll be able to easily check if the
> UUID refers to a filesystem uuid or not.
>
> I can roll that into the next version unless there's specific complaints.

I don't think so. People should stop encoding non-existing stuff in
the /dev namespace. :)

Thanks,
Kay
