Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab2FJEul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 00:50:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51254 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2FJEuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 00:50:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkwNT=DLCm_gfubGV=_SahM5njpA=Z_miA=SEkVeYA9cHMdmA@mail.gmail.com>
References: <CANc+2y48M+K4jvGEes_srYO7rCQcPt4pvcxcvm-Hd+7kKJr6BQ@mail.gmail.com>
	<CAHkwNT=3dGTZTDWi+r7m=K=Pqgv6Txi-xKcpN_pNUJ_WbUaD4w@mail.gmail.com>
	<4FD39A7F.9020106@mvista.com>
	<CAHkwNT=DLCm_gfubGV=_SahM5njpA=Z_miA=SEkVeYA9cHMdmA@mail.gmail.com>
Date: Sun, 10 Jun 2012 10:20:37 +0530
Message-ID: <CANc+2y7dMRQ2C-oTU94gBA11CDrwZFthzOvM4wffV77_wMnchQ@mail.gmail.com>
Subject: Re: Break point not hit while debugging linux kernel with kgdb
From: prasannatsmkumar <prasannatsmkumar@gmail.com>
To: Anil Nair <anilcoll90@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 10:00 AM, Anil Nair <anilcoll90@gmail.com> wrote:
> Hello Sergei,
>
> On Sun, Jun 10, 2012 at 12:18 AM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
>
>>   Yeah, KGDB was accepted into kernel exactly for more "poorly fixed
>> patches" to appear. :-)
>
> I was under the impression that maintainers would never recommend
> kgdb, so never learned to use it.
> If you could guide me and Prasanna on how to use kgdb that would be
> helpful :). If you were saying it sarcastically, then i failed to
> understand it . :P.
>
>>> You have to use gdbserver
>>   gdbserver is only good for debugging the applications.
>
> I never knew that..!.
>
> --
> Regards,
> Anil Nair

In one of the machines I am facing a scenario:
I recompiled Ubuntu linux kernel (with the default config taken from
/boot) and the newly compiled kernel does not boot. After detecting
the hard disk (SCSI device) it panics. I am able to see only a part of
the kernel stack trace due to low resolution so I am in a situation
where I cannot do anything further. In this situation kgdb seems to be
the only way.

Note: The case I mentioned in my first mail is different from this case.
