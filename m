Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab2EIRqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:46:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49012 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab2EIRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <1336573788.14207.208.camel@gandalf.stny.rr.com>
References: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
 <1336096792-25373-1-git-send-email-vnagarnaik@google.com> <1336534682.14207.197.camel@gandalf.stny.rr.com>
 <CAL26m8J9j9oqGRte80Kp7zH8DQr5RuHPS88w7+2hry2E-N7VYg@mail.gmail.com> <1336573788.14207.208.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 9 May 2012 10:46:20 -0700
Message-ID: <CAL26m8KdY3KYO6_TEsuZxQUC6nn3tFzt8y7f6zBymM-pYHZtYw@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] trace: Make removal of ring buffer pages atomic
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 7:29 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> This is far from a hot path. In fact, it's quite slow. Lets not uglify
> code just to optimize something that's not time critical.
>
> Please combine these two into a single loop. The wait for completion is
> fine as a separate loop.
>

Sure, I will update the patch with that change. Have you found any
other issues in testing the patch?

Vaibhav Nagarnaik
