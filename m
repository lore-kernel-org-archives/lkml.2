Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab0DVPkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:40:42 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:54265 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab0DVPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:40:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gjLqktCS1UeCB1sLsruziq0TTPrd3CEEEIIajV7Qzriy+Y8Uj5Aq5RCxphotE7p7SN
         JSCAJWlH6GuZT6cesQAqVec0+28g8PNWZYUZnt+NF5xzmeILEPqWvMHcdS4JrJhm2ztX
         XYXJCPLTZcEvR8e1rXXHROM5Vu/pXJosW9SPc=
MIME-Version: 1.0
In-Reply-To: <1271944622.1776.349.camel@laptop>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
	 <1271879833.1776.186.camel@laptop>
	 <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
	 <1271883496.1776.263.camel@laptop>
	 <1271942430.10448.196.camel@gandalf.stny.rr.com>
	 <x2hc5b2c05b1004220650w53919f62hf3daedb822755bf4@mail.gmail.com>
	 <1271944622.1776.349.camel@laptop>
Date: Thu, 22 Apr 2010 17:40:39 +0200
Message-ID: <k2gc5b2c05b1004220840z59f9417fy723a36a6fe9924dc@mail.gmail.com>
Subject: Re: Considerations on sched APIs under RT patch
From: Primiano Tucci <p.tucci@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would hardly call a global-edf scheduler unique.
I used the word "unique" to underline that it is not a partitioned
scheduling scheme, but ONE global scheduler that manages tasks

> Its a well studied
> algorithm and even available in commercial SMP operating systems

Can you cite me a commercial SMP system that supports
multicore/multiprocessor G-EDF?
Eventually can you cite me an uniprocessor system that support EDF?
In my knowledge the most commercial systems do not ever have the
concept of periodic task, release periods and deadlines (e.g. ,
VXWorks, QNX Neutrino)... how can they support G-EDF?
The other commercial  RT System, in my knoweledge, that support
pediodic tasks such as B&R Automation Runtime components and Beckhoff
Twincat System, only offer a Rate Monotonic scheduling scheme.


> (hopefully soon Linux too, see SCHED_DEADLINE, which will approximate
> global-edf, much like the current SCHED_FIFO approximates global-fifo).
> Implementing this as userspace/middleware seems daft. But if your
> controlling process has a global affinity mask and runs as the highest
> available userspace process priority its still all valid.

It is how it is implemented now, and how it works under VXWorks!
