Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0GLNXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:23:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53241 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0GLNXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OMwfl4awNuP2xHJFfKZ55ZZqshMoYuPxwEz/lPhmrkOxccvDDnQocAK4IYtq8ltBgb
         ULQ7WwVrKcqrjNzm+A3p0dJnDWIxJAUUH7cN8/6QCWoc1Bxzopexx8ovlSwt+vKYjLYx
         iiM3nZlSc+Blrr702K4CyuP/HrpuKW3wJG2sI=
MIME-Version: 1.0
In-Reply-To: <4C3AC187.2080909@gmail.com>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
	<4C3ABF96.9070405@msgid.tls.msk.ru>
	<4C3AC187.2080909@gmail.com>
Date: Mon, 12 Jul 2010 15:15:31 +0200
Message-ID: <AANLkTil0LulVxPS4b0kfbArMeERhOcjRzUoWZZ4sfcDO@mail.gmail.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 9:17 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 07/12/2010 12:09 AM, Michael Tokarev wrote:
>>
>> This looks quite similar to a problem with ext4 and O_SYNC which I
>> reported earlier but no one cared to answer (or read?) - there:
>> http://permalink.gmane.org/gmane.linux.file-systems/42758
>> (sent to qemu-devel and linux-fsdevel lists - Cc'd too).  You can
>> try a few other options, esp. cache=none and re-writing some guest
>> files to verify.
>>
>> /mjt
>
> cool a solution... glad to see... no chance at a bisect with this?
> (getting this down too a commit or two makes things easier)
>
> Justin P. Mattock
>
I didn't even say what kernel version I was using, sorry! Kernel
2.6.34.1+"patches in stable queue for next stable release". I tried
this some time ago with 2.6.33.x(don't remember which version exactly)
and it had the same problem, but at the time I stopped trying thinking
that it was a kvm problem. So basically there's no known(to me) good
version and no, I can't bisect this because this is my production
system. Anyway, I suspect this is reproducible. Am I the only one who
created a virtual hd file on a Btrfs and then used it with kvm/qemu? I
mean, it's not a particularly exotic test-case!


-- 
Giangiacomo
