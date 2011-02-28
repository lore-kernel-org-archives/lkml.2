Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1B1O37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:29:59 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51755 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab1B1O35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:29:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CioNQtvxc6mZJn5T2U0NLbq3Vy1sTRrUYoJ8vb2FjVIllJlN2Qfow2TRMud/iIkZq8
         8x//JluaYs+f1mtVmbj01S79KUnrB74TczJ+mHhBSaxTAcZUfH1GcbPFTti5Me1vjmFU
         NjFgPzc6gF6V9Lo7Egur+Gsie3sXQEmWp78PQ=
MIME-Version: 1.0
In-Reply-To: <20110228131118.GA18193@dhcp231-156.rdu.redhat.com>
References: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com>
	<20110228131118.GA18193@dhcp231-156.rdu.redhat.com>
Date: Mon, 28 Feb 2011 22:29:56 +0800
Message-ID: <AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
Subject: Re: ext2/3/4: punch support?
From: Dave Young <hidave.darkstar@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 9:11 PM, Josef Bacik <josef@redhat.com> wrote:
> On Mon, Feb 28, 2011 at 03:03:40PM +0800, Dave Young wrote:
>> Hi, josef and ext guys
>>
>> Do you have any plan with ext4 hole punching support? And the
>> fallocate for ext2/3?
>>
>> What's the obstacle to work on this? could someone tell the status of
>> this issue?
>
> There is no obstacle, just nobody has bothered to do it.  If you want to do it
> go for it.  Thanks,

Yes, I want to do some kvm image space discard stuff,
I use ext4 as my filesystem, but currently only xfs support something
like trim/discard.

I know general knowledge about ext filesystem, but nearly new to ext4 code,
could you give some hint where to start?

--
Thanks
dave
