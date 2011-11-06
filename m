Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1KFSJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:09:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50770 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1KFSJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:09:16 -0500
MIME-Version: 1.0
In-Reply-To: <4EB6BEFA.6000303@codemonkey.ws>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<4EB6AE34.2000907@redhat.com>
	<CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
	<4EB6BAED.2030400@redhat.com>
	<4EB6BEFA.6000303@codemonkey.ws>
Date: Sun, 6 Nov 2011 20:09:15 +0200
X-Google-Sender-Auth: M-odIdoEew57fJ26cAoKxGQt38c
Message-ID: <CAOJsxLFApM9D_29h+qbU+npJgjKbOVvMBvftvHpmWwSqzE=Pkw@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 7:08 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> I'm quite happy with KVM tool and hope they continue working on it.  My only
> real wish is that they wouldn't copy QEMU so much and would try bolder
> things that are fundamentally different from QEMU.

Hey, right now our only source of crazy ideas is Ingo and I think he's
actually a pretty conservative guy when it comes to technology. Avi
has expressed some crazy ideas in the past but they require switching
away from C and that's not something we're interested in doing. ;-)

                        Pekka
