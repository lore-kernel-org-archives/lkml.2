Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2FNIhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:37:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab2FNIhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:37:11 -0400
Message-ID: <1339663013.2559.10.camel@twins>
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
Date: Thu, 14 Jun 2012 10:36:53 +0200
In-Reply-To: <CABPqkBRnMW=Zmi+DycUPMcYS9cgs8doKZqSR37e1gU6wQnT+nw@mail.gmail.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
	 <1339420814-7379-3-git-send-email-jolsa@redhat.com>
	 <CABPqkBRsBegm6gv6agHcGb0Hh1EWCV5gjVnbbwPHh-eOfROCuw@mail.gmail.com>
	 <20120613131240.GB2538@m.brq.redhat.com>
	 <CABPqkBRdVMzocJu_SJbU81wg6Ef=KgbXw-18tb+bZEon79fVDA@mail.gmail.com>
	 <1339594802.8980.44.camel@twins>
	 <CABPqkBRnMW=Zmi+DycUPMcYS9cgs8doKZqSR37e1gU6wQnT+nw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 15:41 +0200, Stephane Eranian wrote:
> Ok, yes that one. It would have been much nicer to follow the enum
> order. 

Yes.. I should make a list of all the things we should've done
differently. Maybe if that list grows long enough someone gets motivated
enough to rev the format as a whole.

It would be a tedious endeavour since you'd need to have both output
paths available for a good while, but it might be worth it in the long
run depending on how painful the current format becomes.
