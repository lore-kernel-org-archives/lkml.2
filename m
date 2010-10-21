Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0JUAOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:14:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42833 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab0JUAOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:14:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 21 Oct 2010 09:08:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: steve@digidescorp.com
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] nommu: add anonymous page memcg accounting
Message-Id: <20101021090847.b4e23dde.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287578957.2603.34.camel@iscandar.digidescorp.com>
References: <1287491654-4005-1-git-send-email-steve@digidescorp.com>
	<20101019154819.GC15844@balbir.in.ibm.com>
	<1287512657.2500.31.camel@iscandar.digidescorp.com>
	<20101020091746.f0cc5dc2.kamezawa.hiroyu@jp.fujitsu.com>
	<1287578957.2603.34.camel@iscandar.digidescorp.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 07:49:17 -0500
"Steven J. Magnani" <steve@digidescorp.com> wrote:

> On Wed, 2010-10-20 at 09:17 +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 19 Oct 2010 13:24:17 -0500
> > "Steven J. Magnani" <steve@digidescorp.com> wrote:
> > 
> > > On Tue, 2010-10-19 at 21:18 +0530, Balbir Singh wrote:
> > > > * Steven J. Magnani <steve@digidescorp.com> [2010-10-19 07:34:14]:
> > > > > +
> > > > > +At the present time, only anonymous pages are included in NOMMU memory cgroup
> > > > > +accounting.
> > > > 
> > > > What is the reason for tracking just anonymous memory?
> > > 
> > > Tracking more than that is beyond my current scope, and perhaps of
> > > limited benefit under an assumption that NOMMU systems don't usually
> > > work with large files. The limitations of the implementation are
> > > documented, so hopefully anyone who needs more functionality will know
> > > that they need to implement it.
> > > 
> > 
> > What happens at reaching limit ? memory can be reclaimed ?
> 
> I'm not quite sure what you're asking. In my usage, the OOM-killer gets
> invoked and the 'runaway' dosfsck process gets terminated; at that point
> all its memory is freed. 
> 

Hmm. then, most of memcg codes are of no use for NOMMU.
I myself can't maintain NOMMU kernel. So, please test every -rc1 when
this patch merged. OK ?

Thanks,
-Kame

