Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2FMNkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:40:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45370 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2FMNks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:40:48 -0400
Message-ID: <1339594802.8980.44.camel@twins>
Subject: Re: [PATCH 02/19] perf: Add ability to attach user level registers
 dump to sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Date: Wed, 13 Jun 2012 15:40:02 +0200
In-Reply-To: <CABPqkBRdVMzocJu_SJbU81wg6Ef=KgbXw-18tb+bZEon79fVDA@mail.gmail.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
	 <1339420814-7379-3-git-send-email-jolsa@redhat.com>
	 <CABPqkBRsBegm6gv6agHcGb0Hh1EWCV5gjVnbbwPHh-eOfROCuw@mail.gmail.com>
	 <20120613131240.GB2538@m.brq.redhat.com>
	 <CABPqkBRdVMzocJu_SJbU81wg6Ef=KgbXw-18tb+bZEon79fVDA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 15:18 +0200, Stephane Eranian wrote:
> 
> If you look carefully at perf_output_sample(), you will notice that data is
> written in the exact order of the enum perf_event_sample_format. 

Not so actually.. CALLCHAIN is out of order. Not sure why we did that
though.


But it should match the comment near PERF_RECORD_SAMPLE.
