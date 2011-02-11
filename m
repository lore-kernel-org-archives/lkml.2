Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab1BKXAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 18:00:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59326 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291Ab1BKXAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 18:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=tfhFr/eK8GK19p56mJ2tqQoLIh4PreHmfvKG112iG/AYM2/6av0S+2DPVpZZ6CY1AN
         ulQ6HKW9lApI37zX52LElPBVlnQZ8OD2iRHRvQMSrgRxWnkKJUxzJDmEs8/DR6FdtMyj
         to2bonJWBRYeTRIjZSRm0F9hLYu6rrd/vjnpI=
MIME-Version: 1.0
Date: Fri, 11 Feb 2011 23:00:14 +0000
Message-ID: <AANLkTimp5Ho1MLcJov+sBbz9qH9OFLuiCyf1wiQjyfqB@mail.gmail.com>
Subject: Re: ubuntu boot problem after compiling new kernel
From: Matt <jackdachef@gmail.com>
To: Amirali Shambayati <amirali.shambayati@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Anca Emanuel <anca.emanuel@gmail.com>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Thanks Chris and Anca,

>I tried to compile latest kernel(2.6.37). but I receive an assembly
>error: /include/trace/events/kmem.h:45: undefined reference to
>'.L1747'. I didn't have any error at linux-2.6.18.1 compilation. I
>read somewhere that kernel should be compiled by gcc-3.4 .  Thus I
>used gcc-3.4 to compile. Do you think it's a compiler issue? Should I
>use another gcc version?
>Sorry for asking stupid questions from you experts. I'm a newbie at
>working with kernel.

>Thanks in advance

Hi Amirali,

perhaps for 2.6.18* gcc-3.4* is used

but with 2.6.37 you could use the included gcc-4.4.3 (in Ubuntu 10.04)
and gcc-4.4.4
(according to http://distrowatch.com/table.php?distribution=ubuntu)

that worked fine for me in the past.

I don't know if you have full access to it but:

help.ubuntu.com - which is a sort of wiki for Ubuntu can be very
helpful in those things :)


https://help.ubuntu.com/community/Kernel/Compile

might help


If a pre-built vanilla-kernel is alright for you, you can also use the
ones provided by Ubuntu:

http://lwn.net/Articles/321473/
https://wiki.ubuntu.com/Kernel/MainlineBuilds?action=show&redirect=KernelMainlineBuilds


I hope that's what you're looking for


Regards

Matt
