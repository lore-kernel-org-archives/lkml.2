Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2ECSzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:55:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36445 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2ECSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <1336071245.14207.104.camel@gandalf.stny.rr.com>
References: <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
 <1335388704-26790-1-git-send-email-vnagarnaik@google.com> <1336010118.14207.75.camel@gandalf.stny.rr.com>
 <CAL26m8KgvuUGhK_T91fM2dNtFt4+KSOb5-C8yNiZ888BZW1PEg@mail.gmail.com>
 <1336049840.14207.82.camel@gandalf.stny.rr.com> <1336054375.14207.84.camel@gandalf.stny.rr.com>
 <CAL26m8J8=-yvtW+7F+XqTKgZs4NxiT3gSYJFC3RetjBwJvzL2g@mail.gmail.com> <1336071245.14207.104.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 3 May 2012 11:54:35 -0700
Message-ID: <CAL26m8JAjrkWC6YfATHiVaa0mW37e6jp+m_iBdLELpLfgh-qwg@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] trace: Make removal of ring buffer pages atomic
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

On Thu, May 3, 2012 at 11:54 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Would it be possible to put that resize_disabled into the first patch so
> we don't have this bug popping up in a git bisect?
>


Will do.


Vaibhav Nagarnaik
