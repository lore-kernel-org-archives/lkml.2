Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0IRU7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 16:59:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51697 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0IRU7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 16:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bfxr4jbAiqq2BtcTKYdI5kIv53OZ/mAltwvTElc8KQf9nDbYEMqk0GJ2iLV9LIOYg8
         Pyuvgtlc9oBNXa2TiMuqvweYeHPkMX//yYGHIyOpJtHGaj62EvvlKdqj4AkFnvSwjazH
         EkFi60ByFHtns+gMmB0jYi0mpeoiMAhchvqGg=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1009181954010.26813@pobox.suse.cz>
References: <AANLkTikOowB=8=3cnJ0QgJNfBsVeMUrkNT0E0uH2LDXL@mail.gmail.com>
	<alpine.LNX.2.00.1009181954010.26813@pobox.suse.cz>
Date: Sat, 18 Sep 2010 22:59:11 +0200
Message-ID: <AANLkTi=T6N6govmQgv5-=KMvHNBE4sX+hKfSyU6ZhUfa@mail.gmail.com>
Subject: Re: OOPS in hiddev_open on connecting "Logitech MX620 Laser Cordless Mouse"
From: Alex Riesen <raa.lkml@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guillaume Chazarain <guichaz@gmail.com>, Mat <jackdachef@gmail.com>,
        Andreas Bombe <aeb@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 19:56, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 18 Sep 2010, Alex Riesen wrote:
>> [  192.656508] BUG: unable to handle kernel NULL pointer dereference at (null)
>> [  192.658212] IP: [<ffffffff81331108>] hiddev_open+0xd1/0x19f
>> [  192.660745] PGD 79849067 PUD 79a9d067 PMD 0
>> [  192.661291] Oops: 0000 [#1] SMP
>
> Does reverting of commit 8fe294caf8c868edd9046251824a0af91991bf43 fix the
> problem please?

For me too, it does help. No oops after reverting the commit.
