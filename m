Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756Ab2J2Uou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:44:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:47146 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab2J2Uor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:44:47 -0400
Message-ID: <1351543469.4047.24.camel@twins>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load
 Latency
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Mon, 29 Oct 2012 21:44:29 +0100
In-Reply-To: <CABPqkBQ3pdvhV=tYjmdaAFyZFvUsM0PkvVw385c1cLA9_Z3KoQ@mail.gmail.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	 <1351523752-4215-5-git-send-email-eranian@google.com>
	 <20121029194203.GK2266@tassilo.jf.intel.com>
	 <CABPqkBQ3pdvhV=tYjmdaAFyZFvUsM0PkvVw385c1cLA9_Z3KoQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 21:39 +0100, Stephane Eranian wrote:
> But I think the right mechanism would be one where you
> can add events at boot time based on CPU model. It could be used
> to add the common events as well in the common part of the init
> code. 

mlin once posted something like that, it did some scary things with
sysfs without using the driver model -- which might or might not be
'right' (TM).

If someone has the stomach to stare at that code and then convince
gregkh that its not 'wrong' I'm all for it.
