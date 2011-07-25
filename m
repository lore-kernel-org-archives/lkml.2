Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab1GYMmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:42:04 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:34406 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1GYMly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:41:54 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Kevin Wolf <kwolf@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
In-Reply-To: <4E2D608F.6020606@redhat.com>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	 <4E2CA6DE.4040900@web.de>
	 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
	 <20110725075305.GA32294@elte.hu>
	 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
	 <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
	 <4E2D608F.6020606@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 25 Jul 2011 15:41:52 +0300
Message-ID: <1311597712.14203.28.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Mon, 2011-07-25 at 14:24 +0200, Kevin Wolf wrote:
> You've just chosen a different default. I'd argue that most users (i.e.
> not developers of the tool or the kernel) actually want to run with a
> disk image and graphics. You can type "qemu-kvm harddisk.img" and that's
> it. This is clearly superior to something as tedious as "./kvm run -d
> harddisk.img --sdl" and I can assure you that a bash alias is really not
> a solution for that.

I actually agree with you and we eventually want

  kvm run harddisk.img

to do the right thing.

On Mon, 2011-07-25 at 14:24 +0200, Kevin Wolf wrote:
> So, as always, which set of command line switches works better for you
> depends entirely on your use case.

I actually don't agree. I think Qemu requires way too much configuration
from the user and doesn't try hard enough to provide best possible
defaults. Dunno how much virt-manager changes all that, though.

			Pekka

