Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab0JFBEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:04:44 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34301 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab0JFBEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:04:42 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Introduce support for little endian PowerPC
From: Ian Munsie <imunsie@au1.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
In-reply-to: <AANLkTikHcoccu-WGtSOSdkwU6Tw_An_VFkUcEoY==8=c@mail.gmail.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com> <AANLkTikHcoccu-WGtSOSdkwU6Tw_An_VFkUcEoY==8=c@mail.gmail.com>
Date: Wed, 06 Oct 2010 12:04:40 +1100
Message-Id: <1286325582-sup-5109@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

Excerpts from Josh Boyer's message of Fri Oct 01 21:36:35 +1000 2010:
> Aside from my general "uh, why?" stance, I'm very very hesitant to
> integrate anything in the kernel that doesn'.t have released patches
> on the toolchain side.

As I said the kernel can be built today with an unpatched toolchain
targetted at powerpcle-elf, the new powerpcle-linux target is mainly
required for userspace, but yes I want to get those patches out as soon
as possible.

> Also, which uClibc?  The old and crusty uClibc that uses the horrible
> linuxthreads, or the somewhat less crusty that just switched to NPTL
> (which hasn't been verified on normal PowerPC that I recall).  Why not
> use glibc...

As Ben said this was for a proof of concept and changing uClibc to
support it was quite literally a one line change.

I've been using stable packages as my base on the toolchain side of
things (gcc 4.4.4, binutils 2.20.1 and uClibc 0.9.31) so uClibc is still
using linuxthreads since they haven't released a version with NPTL yet.

> I'm not meeting to detract here, but the Kconfig should be dependent
> on && BROKEN until the above is fixed.

Good point.


Cheers,
-Ian
