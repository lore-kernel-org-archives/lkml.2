Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1F2TNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:13:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64897 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1F2TNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:13:09 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	<1308875813-20122-5-git-send-email-wad@chromium.org>
	<BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
	<alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
Date: Wed, 29 Jun 2011 14:13:09 -0500
Message-ID: <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Will Drewry <wad@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: Chris Evans <scarybeasts@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 6:20 PM, James Morris <jmorris@namei.org> wrote:
> On Fri, 24 Jun 2011, Chris Evans wrote:
>
>> With patches like these, there can be the concern: will anyone actually use
>> it??
>
> It's likely to be used by kvm/qemu to help protect against vm break-outs.

Since it seems that there'll be consumers (openssh, vsftpd, kvm/qemu,
chromium, chromium os) and feedback quieted down, what are the next
steps to get this to a pull/no-pull decision points (or at least some
Ack's or Nack's)?  I know this patch series crosses a number of
maintainers, and I never know exactly what's next when the feedback
slows down.

Thanks!
will
