Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2BCPbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:31:17 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43630 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2BCPbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:31:16 -0500
MIME-Version: 1.0
In-Reply-To: <20120203082748.GB782@amit.redhat.com>
References: <20120203082748.GB782@amit.redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 3 Feb 2012 07:30:55 -0800
Message-ID: <CALCETrUpXNkUSGh59+dy=+ocy2=J7G7=nXs4L1girsWFZVGC9g@mail.gmail.com>
Subject: Re: vsyscall=emulate regression
To: Amit Shah <amit.shah@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 12:27 AM, Amit Shah <amit.shah@redhat.com> wrote:
> Hello,
>
> I'm booting some latest kernels on a Fedora 11 (released June 2009)
> guest.  After the recent change of default to vsyscall=emulate, the
> guest fails to boot (init segfaults).

Which kernel is the host running and which kernel is the guest
running?  And which kernel has the vsyscall=emulate parameter?  If
vsyscall=emulate is a problem on a pre-3.3 kernel, can you try
something containing commit 4fc3490114bb159bd4fff1b3c96f4320fe6fb08f?
(UML, for example, is known to have serious issues without that fix.)

Otherwise, can you tell me what hypervisor you're using and what init
version (i.e. the rpm) so I can try to reproduce it?  A pointer to an
actual image would work, too.  A copy of the oops would also be nice.


--Andy
