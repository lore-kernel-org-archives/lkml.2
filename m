Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1KFNLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:11:50 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49373 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1KFNLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:11:48 -0500
MIME-Version: 1.0
In-Reply-To: <4EB680D9.2070706@redhat.com>
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
Date: Sun, 6 Nov 2011 15:11:47 +0200
X-Google-Sender-Auth: JB7vHRDZ6-dw3ClL561CE4TsJhM
Message-ID: <CAOJsxLFqjKizPwk_BODxPNrHncwiBccnLdr4pU9RSc9DYNKztA@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity <avi@redhat.com> wrote:
> Alex's script, though, is just a few dozen lines.  kvm-tool is a 20K
> patch - in fact 2X as large as kvm when it was first merged.  And it's
> main feature seems to be that "it is not qemu".

I think I've mentioned many times that I find the QEMU source terribly
difficult to read and hack on. So if you mean "not qemu" from that
point of view, sure, I think it's a very important point. The command
line interface is also "not qemu" for a very good reason too.

As for virtio drivers and such, we're actually following QEMU's
example very closely. I guess we're going to diverge a bit for better
guest isolation but fundamentally I don't see why we'd want to be
totally different from QEMU on that level.

                        Pekka
