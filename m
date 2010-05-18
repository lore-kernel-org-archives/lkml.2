Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0EROJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:09:07 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab0EROJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:09:04 -0400
Subject: collecting static data related to tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 16:09:02 +0200
Message-ID: <1274191742.31554.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've got some tracing in the wireless subsystem that allows us to find
out what's going on quite well. I frequently ask users to use trace-cmd
to record data and send me the resulting file. (Oh and please ... I
don't care if perf could do this as well, trace-cmd works great for me)

However, in all of this I still have to ask users for things like their
hardware and firmware version etc. I also ask for the kernel version,
but that would be easy to simply record in trace-cmd. However, device
versions are very specific to the tracer in use.

I'm thinking that we could have per subsystem "detail" files that are
provided by the respective subsystem implementation in some way, and can
then simply be included in the recorded trace file. However, I have no
idea if that is feasible to implement, or if maybe there's another way.
FWIW, all my events already contain a pointer, used as a cookie, to
identify the hardware instance, but that only allows me to read a trace
that contains data about multiple devices, it doesn't give me
information about each device. Ideally, the "detail" file would list all
the information along with the cookie, so I could connect the dots.

Thoughts?

johannes

