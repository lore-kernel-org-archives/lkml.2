Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2FMNhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:37:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:60891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2FMNhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:37:34 -0400
Message-ID: <1339594622.8980.42.camel@twins>
Subject: Re: [PATCH 02/19] perf: Add ability to attach user level registers
 dump to sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Date: Wed, 13 Jun 2012 15:37:02 +0200
In-Reply-To: <20120613131240.GB2538@m.brq.redhat.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
	 <1339420814-7379-3-git-send-email-jolsa@redhat.com>
	 <CABPqkBRsBegm6gv6agHcGb0Hh1EWCV5gjVnbbwPHh-eOfROCuw@mail.gmail.com>
	 <20120613131240.GB2538@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 15:12 +0200, Jiri Olsa wrote:
> 
> I dont see any limitation except for being incosistent with the rest
> of
> the sample dumps. I'm all for having that PERF_SAMPLE_USER_REGS bit
> and
> the user stack bit as well. 

Humm,. we don't have a PERF_SAMPLE_ bit anymore? We should have this.

I was only objecting to this other flag word where you were having one
or two bits set for no apparent reason.
