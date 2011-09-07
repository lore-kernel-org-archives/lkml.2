Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1IGT26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:28:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44705 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1IGT25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:28:57 -0400
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        dsahern@gmail.com
Date: Wed, 07 Sep 2011 21:28:46 +0200
In-Reply-To: <CABPqkBRzA32PW2E_wZrESrCQB2KPJqqomZD0M3x4ZBDzWJGi+Q@mail.gmail.com>
References: <20110906204637.GA31826@quad> <1315383151.11101.13.camel@twins>
	 <CABPqkBRzA32PW2E_wZrESrCQB2KPJqqomZD0M3x4ZBDzWJGi+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315423726.11101.27.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 14:55 +0200, Stephane Eranian wrote:
> On Wed, Sep 7, 2011 at 10:12 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2011-09-06 at 22:46 +0200, Stephane Eranian wrote:
> >> +static const char *topo_fmt[] = {
> >> +       "/sys/devices/system/cpu/cpu%d/topology/core_siblings_list",
> >> +       "/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list",
> >> +       NULL
> >> +};
> >
> > No nodes?
> >
> To record what information? core/thread siblings or memory stuff?

Dunno really,.. but nodes are part of the topology and with people
interested in all this uncore business it might make sense to have that.
Maybe even record the node-distance table so you can reconstruct the
interconnect topology.


