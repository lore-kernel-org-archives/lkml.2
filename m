Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1KFMcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 07:32:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54056 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1KFMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 07:32:11 -0500
MIME-Version: 1.0
In-Reply-To: <4EB67D17.7000701@redhat.com>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
Date: Sun, 6 Nov 2011 14:32:10 +0200
X-Google-Sender-Auth: lc4JzwLA9kedb38pul51wMSS8Kg
Message-ID: <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 2:27 PM, Avi Kivity <avi@redhat.com> wrote:
> But from your description, you're trying to solve just another narrow
> problem:
>
> "The end game for me is to replace QEMU/VirtualBox for Linux on Linux
> virtualization for my day to day purposes. "
>
> We rarely merge a subsystem to solve one person's problem (esp. when it
> is defined as "replace another freely available project", even if you
> dislike its command line syntax).

I really don't understand your point. Other people are using the KVM
tool for other purposes. For example, the (crazy) simulation guys are
using the tool to launch even more guests on a single host and Ingo
seems to be using the tool to test kernels.

I'm not suggesting we should merge the tool because of my particular
use case. I'm simply saying the problem I personally want to solve
with the KVM tool is broader than what Alexander's script is doing.
That's why I feel it's a pointless project.

                        Pekka
