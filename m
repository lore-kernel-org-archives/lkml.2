Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2ALRSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:18:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62976 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2ALRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:17:58 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=CN4PQ-MNGcoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=jf1CyLSczCSKpcgWCx8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326388674.7642.103.camel@gandalf.stny.rr.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Date: Thu, 12 Jan 2012 12:17:54 -0500
In-Reply-To: <CA+55aFw2yigXqfiKMH4aZ9w8dOkAEB0cZ2m4ZUEhiddnrQuueg@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	 <1326302710-9427-2-git-send-email-wad@chromium.org>
	 <1326383015.7642.77.camel@gandalf.stny.rr.com>
	 <CAObL_7GVo8rH=Knv=t5VtJG24m7tY9MhNf9QNah+8G9oYiXo6g@mail.gmail.com>
	 <1326385635.7642.89.camel@gandalf.stny.rr.com>
	 <CA+55aFw2yigXqfiKMH4aZ9w8dOkAEB0cZ2m4ZUEhiddnrQuueg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 09:09 -0800, Linus Torvalds wrote:

> The whole "fail security escalations" thing goes way beyond just
> filtering, I think we could seriously try to make it a generic
> feature.

After I wrote this comment I thought the same thing. It would be nice to
have a way to just set a flag to a process that will prevent it from
doing any escalating of privileges.

I totally agree, this would solve a whole host of issues with regard to
security issues in things that shouldn't be a problem but currently are.

-- Steve




