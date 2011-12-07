Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1LGRtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:49:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61465 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab1LGRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:49:15 -0500
MIME-Version: 1.0
In-Reply-To: <1323279116.30977.109.camel@frodo>
References: <1322539673.17003.45.camel@frodo> <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
 <m2r50qlmgk.fsf@firstfloor.org> <1322598920.17003.71.camel@frodo>
 <CA+55aFzgM55hXTs4griX5e9=v_O+=ue+7Rj0PTD=M7hFYpyULQ@mail.gmail.com>
 <1323275800.30977.101.camel@frodo> <CA+55aFzvGcVRDdm82OdjwP-D-fnrgTVFekVVVKYZSbsexGhN-w@mail.gmail.com>
 <1323279116.30977.109.camel@frodo>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Dec 2011 09:48:54 -0800
X-Google-Sender-Auth: BSXg4MmfOHCb4UITweJTu4KUhVQ
Message-ID: <CA+55aFxR738fZ9M-NCP=g5=A1HT6BAJLTPzx5RmRfKxm5vp3jQ@mail.gmail.com>
Subject: Re: Perhaps a side effect regarding NMI returns
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 9:31 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> How about something like this:

Ack, looks good to me,

                   Linus
