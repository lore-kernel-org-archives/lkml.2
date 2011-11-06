Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1KFLIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 06:08:53 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:54213 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1KFLIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 06:08:51 -0500
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
In-Reply-To: <4EB66036.4080102@redhat.com>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	 <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	 <4EB65C5B.8070709@redhat.com>
	 <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	 <4EB66036.4080102@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 06 Nov 2011 13:08:48 +0200
Message-ID: <1320577728.1428.73.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Sun, 2011-11-06 at 12:23 +0200, Avi Kivity wrote:
> > If this is a serious attempt in making QEMU command line suck less on
> > Linux, I think it makes sense to do this properly instead of adding a
> > niche script to the kernel tree that's simply going to bit rot over
> > time.
> 
> You misunderstand.  This is an attempt to address the requirements of a
> niche population, kernel developers and testers, not to improve the qemu
> command line.  For the majority of qemu installations, this script is
> useless.

Right.

On Sun, 2011-11-06 at 12:23 +0200, Avi Kivity wrote:
> In most installations, qemu is driven by other programs, so any changes
> to the command line would be invisible, except insofar as they break things.
> 
> For the occasional direct user of qemu, something like 'qemu-kvm -m 1G
> /images/blah.img' is enough to boot an image.  This script doesn't help
> in any way.
> 
> This script is for kernel developers who don't want to bother with
> setting up a disk image (which, btw, many are still required to do - I'm
> guessing most kernel developers who use qemu are cross-arch).  It has
> limited scope and works mostly by hiding qemu features.  As such it
> doesn't belong in qemu.

I'm certainly not against merging the script if people are actually
using it and it solves their problem.

I personally find the whole exercise pointless because it's not
attempting to solve any of the fundamental issues QEMU command line
interface has nor does it try to make Linux on Linux virtualization
simpler and more integrated.

People seem to think the KVM tool is only about solving a specific
problem to kernel developers. That's certainly never been my goal as I
do lots of userspace programming as well. The end game for me is to
replace QEMU/VirtualBox for Linux on Linux virtualization for my day to
day purposes.

			Pekka

