Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab2DHEH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 00:07:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35130 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2DHEH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 00:07:56 -0400
MIME-Version: 1.0
In-Reply-To: <CANLaLhZWj=FuQkHzBwcZ13tTm8wSgkx1x-R91yQ+oKdtMA=Gxw@mail.gmail.com>
References: <CANLaLhbxq4YEHurBvjfVoA9sUETqcC+bM39=Z84gb_YQAD+ejA@mail.gmail.com>
	<CANLaLhZWj=FuQkHzBwcZ13tTm8wSgkx1x-R91yQ+oKdtMA=Gxw@mail.gmail.com>
Date: Sun, 8 Apr 2012 09:37:54 +0530
Message-ID: <CANLaLhb-bs-NhaRpHzLALPTmzsKzP0RBJLmMy2D7Uq3rhcgDAg@mail.gmail.com>
Subject: Re: Detect whether AHCI is enabled in BIOS
From: Arun Prakash Jana <engineerarun@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK... I found a solution from a friend. Posting it here for later
reference by someone:

root@log0:~# grep ahci /proc/interrupts
 16:       9865   18487739   38032755  142057960   IO-APIC-fasteoi   ahci, ioc0

Regards,

Arun



On Thu, Apr 5, 2012 at 09:36, Arun <engineerarun@gmail.com> wrote:
>
> Any help on this?
>
> Regards,
>
> Arun
>
>
>
> On Mon, Apr 2, 2012 at 23:05, Arun <engineerarun@gmail.com> wrote:
> > Hi,
> >
> > Is there any simple way (like using an ioctl) to detect whether AHCI
> > in enabled in BIOS from userspace applications?
> >
> > Regards,
> >
> > Arun
