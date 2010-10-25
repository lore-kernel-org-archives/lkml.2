Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab0JYAps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:45:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59036 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0JYApr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kzkYGdL7oCcc7w0Cc6XP5Z7Pmouh6Xz+BHjE8ZAr4moH1vib6hbUBnzm5MEL3g/5Pv
         MSnI4GeSdaql49L33zotpqpO291OL3imBIr2X4Tu/WTdy4e2dDhV0+ieOvY0D1GZI+VJ
         orzLmYRjcq7owd56FVTOPrKDvwKsxiosREqwU=
MIME-Version: 1.0
In-Reply-To: <4CC45A22.7090801@redhat.com>
References: <AANLkTikmGE2Pz0=57i4CQZrnunFzQHpmFdha2nwivm=Q@mail.gmail.com>
	<4CC45A22.7090801@redhat.com>
Date: Mon, 25 Oct 2010 08:45:46 +0800
Message-ID: <AANLkTinveacu_w+cFa=o+XhL8oiLykGck+8spY=G1yfd@mail.gmail.com>
Subject: Re: linux-2.6.36 WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Milan Broz <mbroz@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 12:09 AM, Milan Broz <mbroz@redhat.com> wrote:
> On 10/24/2010 03:51 PM, Jeff Chua wrote:
>> Git pulled latest linux 2.6.36 (at
>> 35da7a307c535f9c2929cae277f3df425c9f9b1e), and 2nd mount for loop
>> device resulted in the following error. Has this been reported or
>> shall I bisect?
>>
>> # mount -o loop cd.iso /mnt
>> # umount /mnt
>>
>> # repeat a second time
>> # mount -o loop cd.iso /mnt
>>
>> ------------[ cut here ]------------
>> WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
>
> Please can you try patch I posted here
> http://lkml.org/lkml/2010/10/24/30 ?

Milan,

That worked!

Thanks,
Jeff
