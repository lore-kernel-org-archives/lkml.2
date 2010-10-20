Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0JTMzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:55:32 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:35112 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0JTMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:55:31 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2010 08:55:31 EDT
X-Spam-Processed: digidescorp.com, Wed, 20 Oct 2010 07:49:22 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=19096f736b=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] nommu: add anonymous page memcg accounting
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101020091746.f0cc5dc2.kamezawa.hiroyu@jp.fujitsu.com>
References: <1287491654-4005-1-git-send-email-steve@digidescorp.com>
	 <20101019154819.GC15844@balbir.in.ibm.com>
	 <1287512657.2500.31.camel@iscandar.digidescorp.com>
	 <20101020091746.f0cc5dc2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Digital Design Corporation
Date: Wed, 20 Oct 2010 07:49:17 -0500
Message-ID: <1287578957.2603.34.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 09:17 +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 19 Oct 2010 13:24:17 -0500
> "Steven J. Magnani" <steve@digidescorp.com> wrote:
> 
> > On Tue, 2010-10-19 at 21:18 +0530, Balbir Singh wrote:
> > > * Steven J. Magnani <steve@digidescorp.com> [2010-10-19 07:34:14]:
> > > > +
> > > > +At the present time, only anonymous pages are included in NOMMU memory cgroup
> > > > +accounting.
> > > 
> > > What is the reason for tracking just anonymous memory?
> > 
> > Tracking more than that is beyond my current scope, and perhaps of
> > limited benefit under an assumption that NOMMU systems don't usually
> > work with large files. The limitations of the implementation are
> > documented, so hopefully anyone who needs more functionality will know
> > that they need to implement it.
> > 
> 
> What happens at reaching limit ? memory can be reclaimed ?

I'm not quite sure what you're asking. In my usage, the OOM-killer gets
invoked and the 'runaway' dosfsck process gets terminated; at that point
all its memory is freed. 

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


