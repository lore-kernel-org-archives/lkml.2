Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab2C2ToQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:44:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60963 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2C2ToF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <4F74B42F.3050100@zytor.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
 <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com>
 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
 <4F73CC3A.2080901@zytor.com> <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
 <20120329062031.GB1376@gmail.com> <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com>
 <4F74B42F.3050100@zytor.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 29 Mar 2012 12:43:33 -0700
Message-ID: <CAL26m8JA4HJQayJW2nYbVpHD7mgd0Bz6rFMipq2Nf6OECiyk1Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace handler
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, Michael Davidson <md@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 12:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> ANY increase to the fastpath is unacceptable, period.

I agree.

I know that this or any similar solutions won't be acceptable
upstream, but it works for us within the current syscall tracing
framework.

> Furthermore, as I have discussed with some people over the last few
> days, I think we should consider the whole syscall tracing interface set
> to be a mistake and deprecate it.  There are much better ways to
> accomplish something that will work more reliable without all these thunks.


We rely heavily on a system-wide tracing framework and having the
capability of syscall tracing in the kernel helps with debugging
performance issues. ftrace is the best tool for us in this respect.

However, we agree that the syscall tracing as implemented currently is
a bit unwieldy. We would want to be a part of the re-designing effort
if there is a momentum in the community towards that goal. We would be
happy to contribute towards this effort.


Thanks

Vaibhav Nagarnaik
