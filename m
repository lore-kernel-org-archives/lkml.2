Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2LTSnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:43:18 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:62205 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2LTSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:43:06 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 13:43:06 EST
MIME-Version: 1.0
In-Reply-To: <CAMe9rOoxTqF3PpvhS-+K40e-3fCELJUQhCjRPenZOi=Df895fg@mail.gmail.com>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
 <1355823656-13902-7-git-send-email-stefani@seibold.net> <50D09733.3080502@zytor.com>
 <1355849558.26967.24.camel@wall-e> <50D0B986.7020009@zytor.com>
 <1355862759.28056.14.camel@wall-e> <CALCETrX2zAA-X7fjoPNSERq0kVDDY43O_u=Oqjq77_ggf64j9A@mail.gmail.com>
 <1355989294.24672.9.camel@wall-e> <a881f355-720c-40aa-ad96-60fc86e96d53@email.android.com>
 <1356025992.25530.1.camel@wall-e> <50D35713.1090506@zytor.com> <CAMe9rOoxTqF3PpvhS-+K40e-3fCELJUQhCjRPenZOi=Df895fg@mail.gmail.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Thu, 20 Dec 2012 10:35:49 -0800
Message-ID: <CAB=4xhpXojoeNdThEQi3CH_fhsAqk63_G5zYgMTvoPxn5nE7Zg@mail.gmail.com>
Subject: Re: [PATCH 6/6] Add 32 bit VDSO support for 32 and 64 bit kernels
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig text for COMPAT_VDSO suggests that glibc versions prior to
2.3.3 may have relied on the fixed address.  I can't find anything in the
libc revision history to explain that (AFAIK the code always used
AT_SYSINFO* since it started using the vDSO at all), but it might have been
something less obvious.  Someone like Jakub might recall the details.
