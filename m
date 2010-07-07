Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0GGH5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 03:57:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58270 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0GGH52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 03:57:28 -0400
Date: Wed, 7 Jul 2010 09:57:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/21] perf: Export trace event utils
Message-ID: <20100707075722.GA24587@aftab>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
 <1277999763-20357-16-git-send-email-bp@amd64.org>
 <1278454723.1537.60.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278454723.1537.60.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, Jul 06, 2010 at 06:18:43PM -0400

Hi Steven,

> I'm actually working on making a libparsevent.a that does some of what
> you are doing.
> 
> The idea is, if I can separate out this code from perf, I can then bring
> it up to speed with what I have in trace-cmd.

Ok this is good. I moved those to a generic place only because
perf/util/parse-events.c pulled them out as a build dependency but all
the trace events parsing code should be a library-like since it can very
much be reused by a lot of other tools.

We should sync our stuff then, after you've moved those to
tools/lib/trace/ or somewhere similar, and I can rebase my stuff on top. Or
maybe you have a better idea, please keep me posted so that we don't step on
each other's toes.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
