Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1EZI5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:57:54 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65274 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1EZI5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BrpXxi5AKd6V2+PqziofFSPywkGvVTce4m4gm/5leBcMuHDuz9BtamDC2N1GbXqg3/
         VEs7CXsfQ46tSfFjSDokTiik5/sWpiG67Y2nupdjnahK2RW+0RG+ZrUtYQ06b5YX9+H3
         0kwVC0GHKFNLhjXG3KyTod3HNYY0rwGligEy8=
MIME-Version: 1.0
In-Reply-To: <4DDE1419.3000708@redhat.com>
References: <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
	<BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
	<1306254027.18455.47.camel@twins>
	<20110524195435.GC27634@elte.hu>
	<alpine.LFD.2.02.1105242239230.3078@ionos>
	<20110525150153.GE29179@elte.hu>
	<alpine.LFD.2.02.1105251836030.3078@ionos>
	<20110525180100.GY19633@outflux.net>
	<BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
	<alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
	<20110526082451.GB26775@elte.hu>
	<4DDE1419.3000708@redhat.com>
Date: Thu, 26 May 2011 11:57:51 +0300
X-Google-Sender-Auth: dS8LETJPo_gp42c6gn5d2iHL3PY
Message-ID: <BANLkTind9dUu3=OkSjXrkmrh5ik6xxT=vw@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Thu, May 26, 2011 at 11:49 AM, Avi Kivity <avi@redhat.com> wrote:
> You mean each thread will have a different security context?  I don't see
> the point.  All threads share all of memory so it would be trivial for one
> thread to exploit another and gain all of its privileges.

So how would that happen? I'm assuming that once the security context
has been set up for a thread, you're not able to change it after that.
You'd be able to exploit other threads through shared memory but how
would you gain privileges?

                        Pekka
