Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1KHP0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:26:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37590 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab1KHP0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:26:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111108145257.GA10846@infradead.org>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<4EB93FA4.8020800@redhat.com>
	<20111108145257.GA10846@infradead.org>
Date: Tue, 8 Nov 2011 17:26:03 +0200
X-Google-Sender-Auth: gCQGsG7sWNbdbaZQ0uaN_KDLaJA
Message-ID: <CAOJsxLE5PxhqC5DfHOqgoSXbUOPcHZUKL5QUSGL1fuEkYp26YQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "Am?rico Wang" <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 4:52 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Nevermind that running virtfs as a rootfs is a really dumb idea.  You
> do now want to run a VM that has a rootfs that gets changed all the
> time behind your back.

It's rootfs binaries that are shared, not configuration. It's
unfortunate but works OK for the single user use case it's meant for.
It's obviously not a proper solution for the generic case. We were
hoping that we could use something like overlayfs to hide the issue
under the rug. Do you think that's also a really dumb thing to do?

Using block device snapshotting would be interesting and we should
definitely look into that.

                                Pekka
