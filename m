Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab0GONjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 09:39:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38771 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0GONjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 09:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HNVD6vbAwfJLE45lsSv3SWawxLGkc5qSWLFJtgoe806wHrLafpktEiM1z3a3Rizxc1
         3kyIIhL7V85nETPX3gGjICIaFNFn0qZaV9bXvmSaxj1ZWgmZxpbzRB2a+ZsQlJZHobvh
         LVWhkD4AHgHJL3OSOFlFjReS/mgdGrn/FIMNA=
MIME-Version: 1.0
In-Reply-To: <AANLkTilW7OtG9SvQdXmaHhLi4ZVKTrdmTFpVIOPeVSai@mail.gmail.com>
References: <AANLkTikVDFL1oBg6jAyH3PmJNczOPknskjjkMSJK8Nhp@mail.gmail.com>
	<AANLkTilW7OtG9SvQdXmaHhLi4ZVKTrdmTFpVIOPeVSai@mail.gmail.com>
Date: Thu, 15 Jul 2010 21:39:21 +0800
Message-ID: <AANLkTilKD2xU20E6j6AEwmhzGjuf8CVvO1E_v6gnKiYW@mail.gmail.com>
Subject: Re: [Xen-users] how to complie 2.6.34 dom0 kernel to bzImage (Nothing 
	to be done for `bzImage)
From: lei yang <yanglei.fage@gmail.com>
To: "Fajar A. Nugraha" <fajar@fajar.net>
Cc: Xen Mailing List <xen-users@lists.xensource.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 6:44 PM, Fajar A. Nugraha <fajar@fajar.net> wrote:
> On Thu, Jul 15, 2010 at 4:34 PM, lei yang <yanglei.fage@gmail.com> wrote:
>> All,
>>
>> I patched linux-2.6.34 with xen patches
>>
>> I find if I don't enable XEN ,use default kernel config
>> :i386_defconfig, make bzImage can build well
>>
>>
>> if I enable  XEN:eg: CONFIG_X86_XEN=y
>>
>> [lyang0@ala-lpggp1 linux-2.6.34]$ make ARCH=i386 bzImage
>> scripts/kconfig/conf -s arch/x86/Kconfig
>> #
>> # configuration written to .config
>> #
>> make: Nothing to be done for `bzImage'.
>
> Short answer: don't run make bzImage. Simply run "make", and you'll
> have vmlinuz (./arch/x86/boot/vmlinuz) which you can use.
>
>>

Actually, I need to use bzImage, becasue I want to use gpxe to boot it
which not support vmlinuz

>> Note:2.6.33 works well
>
> Is this 2.6.33 pv_ops from Jeremy's git tree? pv_ops and Novell's xen
> patches are somewhat different, so something that works on pv_ops may
> or may not work on Novell's xen patches, and vise versa.
>
> --

Yep, I use Jeremy' s tree.


> Fajar
>
