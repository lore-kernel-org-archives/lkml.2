Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab2EaT0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:26:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44905 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab2EaT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:26:17 -0400
Date: Thu, 31 May 2012 21:26:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531192644.GA16998@aftab.osrc.amd.com>
References: <4FBE7755.2080301@redhat.com>
 <20120529115851.GB29157@aftab.osrc.amd.com>
 <4FC4D6E2.9060501@redhat.com>
 <20120529145245.GG29157@aftab.osrc.amd.com>
 <4FC4E9EB.5030801@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
 <20120531100005.GC14074@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6C61@ORSMSX104.amr.corp.intel.com>
 <20120531172018.GO14515@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6CE1@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F6CE1@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 06:14:56PM +0000, Luck, Tony wrote:
> > Ok, thus the dynamic granularity. But we're going to end up reporting
> > rank and row too so that it can be matched to the DIMM. I consider
> > physical address a bonus in such cases and it is only of importance to
> > those who like to replace single DRAM chips or single MOSFET transistors
> > :-) :-) :-).
> 
> Perhaps you don't really need to replace your 32GB DIMM because a single
> bit is stuck (one bad bit out of > 300 billion). With the physical address
> we can tell Linux to try to stop using the page that contains the stuck
> bit - most of the time it can do that.

Yes, ok, that is a good example for using the physical address.
Provided, of course, the reported granularity still keeps us within the
page that contained the error. But I think you said earlier that most of
the errors are reported with 4K granularity, so all is fine.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
