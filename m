Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2JVRJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:09:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:56783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab2JVRJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:09:19 -0400
Message-ID: <1350925708.2768.106.camel@twins>
Subject: Re: [PATCH v2 1/2] perf tools: add event modifier to request
 exclusive PMU access
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Mon, 22 Oct 2012 19:08:28 +0200
In-Reply-To: <CABPqkBQ26K9iT6Kkzwg1XFvbz+ByKSoPGcyUDXrTq2+thqFBtA@mail.gmail.com>
References: <1350912052-10066-1-git-send-email-eranian@google.com>
	 <1350912052-10066-2-git-send-email-eranian@google.com>
	 <20121022135358.GJ2095@tassilo.jf.intel.com>
	 <CABPqkBTJsZHdvp+Tm3SGJCfJ7eMFaqQR8pd9eoh5KyBo3k6o3Q@mail.gmail.com>
	 <20121022153952.GM2095@tassilo.jf.intel.com>
	 <CABPqkBTeuD==RY9xORYyUhtZm0cXAFw7FEPocMsdCbcqTUS3bg@mail.gmail.com>
	 <1350921565.2768.105.camel@twins>
	 <CABPqkBQ26K9iT6Kkzwg1XFvbz+ByKSoPGcyUDXrTq2+thqFBtA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 18:08 +0200, Stephane Eranian wrote:
> > I'm still wondering if the avg user really thinks 'instructions' is
> a
> > useful metric for other than obtaining ipc measurements.
> >
> Yeah, for many users CPI (or IPC) is a useful metric. 

Right but you don't get that using instruction sampling, right? Or you
need to pair it with a cycle count one way or another. And I don't
really see PDIST helping with that.
