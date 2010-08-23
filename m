Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0HWIMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:12:38 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:43083 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0HWIMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:12:35 -0400
Date: Mon, 23 Aug 2010 10:12:12 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dkiper@net-space.pl, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Fix apic=debug boot crash
Message-ID: <20100823081212.GA13297@router-fw-old.local.net-space.pl>
References: <20100819224616.GB9967@router-fw-old.local.net-space.pl> <tip-05e407603e527f9d808dd3866d3a17c2ce4dfcc5@git.kernel.org> <AANLkTim9kjBp68LqieU3MDLbkRDiWLNQjtUvjEbc9Hca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim9kjBp68LqieU3MDLbkRDiWLNQjtUvjEbc9Hca@mail.gmail.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 20, 2010 at 12:24:20PM -0700, Yinghai Lu wrote:
> On Fri, Aug 20, 2010 at 5:41 AM, tip-bot for Daniel Kiper
> <dkiper@net-space.pl> wrote:
> > Commit-ID: ?05e407603e527f9d808dd3866d3a17c2ce4dfcc5
> > Gitweb: ? ? http://git.kernel.org/tip/05e407603e527f9d808dd3866d3a17c2ce4dfcc5
> > Author: ? ? Daniel Kiper <dkiper@net-space.pl>
> > AuthorDate: Fri, 20 Aug 2010 00:46:16 +0200
> > Committer: ?Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 20 Aug 2010 10:18:28 +0200
> >
> > x86, apic: Fix apic=debug boot crash
> >
> > Fix a boot crash when apic=debug is used and the APIC is
> > not properly initialized.
> >
> > This issue appears during Xen Dom0 kernel boot but the
> > fix is generic and the crash could occur on real hardware
> > as well.
>
> Do you have any report on real hardware?
> that could not happen on real hardware.

Till now no, however I think it is good idea
to apply this patch now. It is not worth to wait
for another null pointer dereference.

Daniel
