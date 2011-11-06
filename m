Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1KFWJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:09:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1KFWJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:09:04 -0500
To: Pekka Enberg <penberg@kernel.org>
Cc: Alexander Graf <agraf@suse.de>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Blue Swirl <blauwirbel@gmail.com>, Avi Kivity <avi@redhat.com>,
        =?us-ascii?Q?=3D=3FISO-8859-1=3FQ=3FAm=3DE9rico=5FWang=3F=3D?= 
	<xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
	<E0D7D6BB-AB05-43DA-B679-BB2C3CA43E2C@suse.de>
Message-Id: <20111106220848.9C2D258166@fche.csb>
Date: Sun,  6 Nov 2011 17:08:48 -0500 (EST)
From: fche@redhat.com (Frank Ch. Eigler)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$	<CAOJsxLFCjkAK7Lw4M15G44k11zrcF7tnu9yMbiQYDBNZr+83tg@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sun, 06 Nov 2011 17:08:48 -0500
In-Reply-To: <CAOJsxLFCjkAK7Lw4M15G44k11zrcF7tnu9yMbiQYDBNZr+83tg@mail.gmail.com> (Pekka Enberg's message of "Sun, 6 Nov 2011 20:05:45 +0200")
Message-ID: <y0mhb2g6gzz.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


Pekka Enberg <penberg@kernel.org> writes:

> [...]  We don't want to be different, we want to make the barrier of
> entry low.

When has the barrier of entry into the kernel ever been "low"
for anyone not already working in the kernel?

- FChE
