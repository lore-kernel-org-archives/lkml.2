Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab1GAM4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:56:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40682 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1GAM4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:56:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110701115600.GK20990@elte.hu>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	<1308875813-20122-5-git-send-email-wad@chromium.org>
	<BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
	<alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
	<BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
	<alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
	<20110701115600.GK20990@elte.hu>
Date: Fri, 1 Jul 2011 07:56:37 -0500
Message-ID: <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Will Drewry <wad@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, Chris Evans <scarybeasts@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 6:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * James Morris <jmorris@namei.org> wrote:
>
>> On Wed, 29 Jun 2011, Will Drewry wrote:
>>
>> > Since it seems that there'll be consumers (openssh, vsftpd,
>> > kvm/qemu, chromium, chromium os) and feedback quieted down, what
>> > are the next steps to get this to a pull/no-pull decision points
>> > (or at least some Ack's or Nack's)?  I know this patch series
>> > crosses a number of maintainers, and I never know exactly what's
>> > next when the feedback slows down.
>>
>> Are there any outstanding objections to this approach?  How do the
>> tracing folk feel about it?
>
> I think i outlined my objections a couple of times and haven't seen
> them addressed.

After our last discussion, I suggested changes which I then undertook
and reposted.  Those changes have been posted for over two weeks.
I've continued to resolve any bugs with the patches and keep them
rebased.

Is it just that you will not accept the prctl()-based approach?  If
that's the case, I'm confused as it doesn't seem like there was
support for a perf-based change or a change that was more fundamental.

If you would re-outline the places where it falls down, that would be
useful.  If it is just that you do not think we can reach agreement,
that would be useful to know as well.

thanks,
will
