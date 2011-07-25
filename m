Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1GYHum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:50:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55457 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1GYHug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:50:36 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Sasha Levin <levinsasha928@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Pekka Enberg <penberg@kernel.org>, torvalds@linux-foundation.org,
        mingo@elte.hu, avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
In-Reply-To: <4E2CA6DE.4040900@web.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	 <4E2CA6DE.4040900@web.de>
Content-Type: text/plain; charset="iso-8859-7"
Date: Mon, 25 Jul 2011 10:50:01 +0300
Message-ID: <1311580201.3446.30.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 01:12 +0200, Jan Kiszka wrote:
> On 2011-07-24 22:37, Pekka Enberg wrote:
> > Hi Linus,
> > 
> > Please consider pulling from
> > 
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git
> > kvm-tool-for-linus
> > 
> > to merge the Native Linux KVM tool to Linux 3.1.
> > 
> > [ The changes to 9p headers were already merged but show up in the pull
> > request. ]
> > 
> > The goal of this tool is to provide a clean, from-scratch, lightweight
> > KVM host
> > tool implementation that can boot Linux guest images with no BIOS
> > dependencies
> > and with only the minimal amount of legacy device emulation. The primary
> > focus
> > of the tool is to Linux but there are already people on working on
> > supporting
> > GRUB and other operating systems.
> > 
> > We want the tool to be part of Linux kernel source tree because we
> > believe that
> > ¡perf¢ clearly showed the benefits of a single repository for both
> > kernel and
> > userspace components. See Ingo Molnar¢s email that started the project for
> > details:
> > 
> >   http://thread.gmane.org/gmane.linux.kernel/962051/focus=962620
> 
> I've read several times now that developing in a single tree leads to
> better results. Can you provide some example from the QEMU/KVM projects
> where the split is preventing innovation, optimizations, or some other
> kind of progress?
> 

Anthony had a talk on last years KVM forum regarding the QEMU threading
model (slide:
http://www.linux-kvm.org/wiki/images/7/70/2010-forum-threading-qemu.pdf) .

It was suggested that the KVM part of QEMU is having a hard time
achieving the ideal threading model due to its need to support TCG -
something which has nothing to do with KVM itself.


-- 

Sasha.

