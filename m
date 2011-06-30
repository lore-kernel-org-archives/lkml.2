Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab1F3Bbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:31:38 -0400
Received: from tundra.namei.org ([65.99.196.166]:57993 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1F3Bbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:31:32 -0400
Date: Thu, 30 Jun 2011 11:30:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Will Drewry <wad@chromium.org>
cc: Chris Evans <scarybeasts@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com,
        Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org, fweisbec@gmail.com,
        tglx@linutronix.de, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter
 is and how it works.
In-Reply-To: <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org> <1308875813-20122-5-git-send-email-wad@chromium.org> <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com> <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
 <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Will Drewry wrote:

> Since it seems that there'll be consumers (openssh, vsftpd, kvm/qemu,
> chromium, chromium os) and feedback quieted down, what are the next
> steps to get this to a pull/no-pull decision points (or at least some
> Ack's or Nack's)?  I know this patch series crosses a number of
> maintainers, and I never know exactly what's next when the feedback
> slows down.

Are there any outstanding objections to this approach?  How do the tracing 
folk feel about it?

-- 
James Morris
<jmorris@namei.org>
