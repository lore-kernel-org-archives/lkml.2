Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab1LGXcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:32:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1LGXcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:32:24 -0500
Date: Wed, 7 Dec 2011 15:32:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/2] selftests: New x86 breakpoints selftest
Message-Id: <20111207153223.4885bab9.akpm@linux-foundation.org>
In-Reply-To: <1322840475-19553-2-git-send-email-fweisbec@gmail.com>
References: <1322840475-19553-1-git-send-email-fweisbec@gmail.com>
	<1322840475-19553-2-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Dec 2011 16:41:15 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Bring a first selftest in the relevant directory.

That all looks nice and simple, thanks.  Unless I get suitably shouted
at I think I'll send all this Linuswards.  Then I can hassle people to
add their little test snippets as they add userspace-visible features.

I don't think we'd ever want to turn this into some huge kernel
verification suite.  My thinking here is that I frequently see that
people have written little test cases for their new feature, but those
test cases just die after the feature is merged.  It would be better to
maintain and grow these tests as the relevant features are augmented or
bugfixed.

All these features are Linux-specific.  Standard interface features (eg
POSIX) are and should be tested via other externally-maintained test
suites.

If the whole idea ends up not working out, we can just delete it all.
