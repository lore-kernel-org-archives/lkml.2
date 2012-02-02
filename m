Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab2BBTWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:22:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36497 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364Ab2BBTVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:21:01 -0500
MIME-Version: 1.0
In-Reply-To: <1328150554.5882.83.camel@gandalf.stny.rr.com>
References: <1314062244-2997-1-git-send-email-vnagarnaik@google.com>
 <1318382410-14967-1-git-send-email-vnagarnaik@google.com> <CAL26m8JSL504zUX+P8WbjOUUjG2WR9idQrh2T8noYrmQYObj4A@mail.gmail.com>
 <1328150554.5882.83.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 2 Feb 2012 11:20:29 -0800
Message-ID: <CAL26m8KNg8R5O64p3YYb0B2aRqr2PBS5u8CVFWbMmgExUegMXA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] trace: Add per_cpu ring buffer control files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 6:42 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> I was thinking there was issues before and thought there was going to be
> another round of patches or something.

I did send those updated patches with changes according to your
feedback. Although, I just checked and the patches don't merge cleanly
to the latest upstream HEAD. I am sending out the rebased patches.

>
> I'll see if I can squeeze out some time to review them again. I'm
> currently hunting down some other bugs.
>

Thanks.


Vaibhav Nagarnaik
