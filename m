Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1LXDCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 22:02:34 -0500
Received: from ozlabs.org ([203.10.76.45]:53210 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab1LXDCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 22:02:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESENDx2] [PULL] virtio: fix barriers for virtio-mmio
In-Reply-To: <CAK=WgbacH1tXHJiHNKLNNsFA7-vnFT_J6vYOANh0wzGyUj8Zpg@mail.gmail.com>
References: <8739cbkgv2.fsf@rustcorp.com.au> <CA+55aFyvMkAtXPRxiFR+UpZKGHMhp8Vd9aYg1dkaoKMwD5MLcw@mail.gmail.com> <CA+55aFzKU0GWqpQo2AzAawoVm=qPaJiwKTcifeYApyZP_Hj3nQ@mail.gmail.com> <CAK=WgbacH1tXHJiHNKLNNsFA7-vnFT_J6vYOANh0wzGyUj8Zpg@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 24 Dec 2011 13:31:14 +1030
Message-ID: <87pqfeisg5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011 13:35:26 +0200, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Fri, Dec 23, 2011 at 11:35 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On x86, there really is never any reason to use the heavy memory
> > barriers unless you are talking to a real device. And last I saw,
> > "virtio" was still about virtual IO.

Not any more, as the commit message describes.

But I missed that they're using rpmsg, which isn't merged yet.

Sorry for the noise,
Rusty.
PS. Switching barriers by bus type is too crude anyway, let's come up
    with something better...
