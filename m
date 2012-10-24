Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab2JXCOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:14:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56229 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2JXCO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:14:28 -0400
MIME-Version: 1.0
In-Reply-To: <20121024015613.GB2616@ZenIV.linux.org.uk>
References: <20121019213548.GR2616@ZenIV.linux.org.uk> <5082A1F1.3080303@tilera.com>
 <20121020153401.GT2616@ZenIV.linux.org.uk> <20121020171643.GU2616@ZenIV.linux.org.uk>
 <5086D432.4070008@tilera.com> <20121023184122.GZ2616@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1210232232070.2756@ionos> <20121023205119.GA27729@sigill.intra.peff.net>
 <alpine.LFD.2.02.1210232307480.2756@ionos> <CA+55aFyYD2jvD3+TSe=GhBgg5UQt2RNFdYf6HGiKRX-xWzFmdw@mail.gmail.com>
 <20121024015613.GB2616@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Oct 2012 05:14:07 +0300
X-Google-Sender-Auth: jj0Jv4EcAA9loWtqHapB5S2w0PY
Message-ID: <CA+55aFzg6cNFCCucwgFnJpgokwM=wkkXPMtd2XbtQB5m9UHOSA@mail.gmail.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and GENERIC_KERNEL_EXECVE
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jeff King <peff@peff.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>, git@vger.kernel.org,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> How about git commit --allow-empty, with
> "belated ACK for <commit>

Don't bother. It's not that important, and it's just distracting.

It's not like this is vital information. If you pushed it out without
the ack, it's out without the ack. Big deal.

          Linus
