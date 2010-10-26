Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab0JZPHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:07:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796Ab0JZPHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <tip-c3b87c579e5df72a59fe97d77d4c3791dc8154ec@git.kernel.org>
References: <tip-c3b87c579e5df72a59fe97d77d4c3791dc8154ec@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Oct 2010 08:06:40 -0700
Message-ID: <AANLkTin7Daj=HnWXstuWxymjuBfF9axfKZWvei_EKefw@mail.gmail.com>
Subject: Re: [tip:perf/urgent] tracing: Prevent unloadable modules from using trace_bprintk()
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        fweisbec@gmail.com, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 3:21 AM, tip-bot for Steven Rostedt
<srostedt@redhat.com> wrote:
>
> tracing: Prevent unloadable modules from using trace_bprintk()

I still don't think this patch makes sense.

Some of it is just totally insane. The CONFIG_MODVERSIONS check is
just crazy. MODVERSIONS has nothing what-so-ever to do with the issue.

Don't do this. It's total voodoo programming.

                   Linus
