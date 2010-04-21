Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0DUUqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:46:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61061 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0DUUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=arcR4lt1vVdlg5k0o1Up3RcFBY2oguOSpIr6wWq0sm8+bEfRpVC3oY0rFqlSRq0GC6
         5La9wa7MS944XO594dCwoIygLX91vIwCw7lhoWMdfDHOcjW452pCAm9iH9JI4D3B+Hn7
         APKxSedHGfNCLB3JrHC0ZXKSaKLwkfVVsHRTE=
MIME-Version: 1.0
In-Reply-To: <1271879833.1776.186.camel@laptop>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
	 <1271879833.1776.186.camel@laptop>
Date: Wed, 21 Apr 2010 22:38:36 +0200
Message-ID: <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
Subject: Re: Considerations on sched APIs under RT patch
From: Primiano Tucci <p.tucci@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, any syscall can end up blocking/scheduling there are no exceptions.
> But blocking doesn't mean its non-deterministic, esp. when coupled with
> things like PI.
>
> But you do have to treat system resources as such, that is they can (and
> will) create cross-cpu dependencies, if you do not take that into
> account you will of course be surprised.
>
I actually don't understand why do you recall PI so frequently, it
seems to be the unique point of interest.
Actually I take care about not sharing cross-cpu resources, but I
cannot take care of what the kernel should do.
In my viewpoint is unacceptable that the scheduler apis can led into a
rescheduling.
It voids any form of process control.
If I lose the control while controlling other processes, Quis
custodiet ipsos custodes?

P.S. It actually does not happen in other RTOSes, e.g., VxWorks SMP

Primiano,

--
 Primiano Tucci
 http://www.primianotucci.com
