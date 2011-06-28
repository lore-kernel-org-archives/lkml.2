Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1F1Pgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:36:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19924 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634Ab1F1Pca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:32:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Wnq+W+De1EaO3455UrksqafD8Slz7X3Ip02TFOyu3L7JxcMnhECMeli0ZUY5H+vJC
	pnVBiOk5RE8vKeOWk7zNg==
MIME-Version: 1.0
In-Reply-To: <20110628152827.GE1159@sun>
References: <20110623124918.GC13050@sun>
	<20110627190358.GQ3765@redhat.com>
	<20110627193201.GB1159@sun>
	<CABPqkBTE_6ma70ZQbbz1NnznCGB7YO74kmL+=fP66qFVvVFLBw@mail.gmail.com>
	<20110628152827.GE1159@sun>
Date: Tue, 28 Jun 2011 17:32:27 +0200
Message-ID: <CABPqkBQSWFa0eSTdx+DeOERaT2wA+2tYbUPereztL7FznF4j7g@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 5:28 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Jun 28, 2011 at 05:24:36PM +0200, Stephane Eranian wrote:
> ...
>> >
>> > Yeah, not the _best_ place. Not sure too where to put it, patches are welcome ;)
>> >
>> No matter what, this file has to remain in a file that's common to all arch.
>
> well, hard to say, Stephane, nmi-watchdog is x86 specific as far as I know.
>
Sorry I was talking about the weak function() not the file.

>        Cyrill
>
