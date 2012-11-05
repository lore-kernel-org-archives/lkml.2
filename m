Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab2KEWPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:15:47 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.29]:57020
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753909Ab2KEWPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:15:45 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -8
X-BigFish: PS-8(zz98dI9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <gregkh@linuxfoundation.org>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Ying Han <yinghan@google.com>
Subject: RE: [PATCH 1/2] mm: Export vm_committed_as
Thread-Topic: [PATCH 1/2] mm: Export vm_committed_as
Thread-Index: AQHNpOUVxeGuP2ksmkqoWwiw1ukrt5eukjYAgAAumACAAKkDgIAB+liAgCbqv6CAA6TlAIAAA/OA
Date: Mon, 5 Nov 2012 22:12:25 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930DFA7B8@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-1-git-send-email-kys@microsoft.com>
	<20121008004358.GA12342@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF930A1FB31@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20121008133539.GA15490@kroah.com>
	<20121009124755.ce1087b4.akpm@linux-foundation.org>
	<426367E2313C2449837CD2DE46E7EAF930DF7FBB@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20121105134456.f655b85a.akpm@linux-foundation.org>
In-Reply-To: <20121105134456.f655b85a.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CMPXCHG.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(377454001)(13464001)(51704002)(44976002)(4396001)(74662001)(53806001)(54316001)(46102001)(49866001)(47976001)(16676001)(46406002)(50466001)(47736001)(50986001)(47776002)(76482001)(6806001)(31966008)(54356001)(51856001)(47446002)(5343635001)(33656001)(23726001)(74502001);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0656A4403B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Monday, November 05, 2012 4:45 PM
> To: KY Srinivasan
> Cc: Greg KH; olaf@aepfle.de; linux-kernel@vger.kernel.org; andi@firstfloor.org;
> apw@canonical.com; devel@linuxdriverproject.org; linux-mm@kvack.org;
> Hiroyuki Kamezawa; Michal Hocko; Johannes Weiner; Ying Han
> Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
> 
> On Sat, 3 Nov 2012 14:09:38 +0000
> KY Srinivasan <kys@microsoft.com> wrote:
> 
> >
> >
> > > >
> > > > Ok, but you're going to have to get the -mm developers to agree that
> > > > this is ok before I can accept it.
> > >
> > > Well I guess it won't kill us.
> >
> > Andrew,
> >
> > I presumed this was an Ack from you with regards to exporting the
> > symbol. Looks like Greg is waiting to hear from you before he can check
> > these patches in. Could you provide an explicit Ack.
> >
> 
> Well, I do have some qualms about exporting vm_committed_as to modules.
> 
> vm_committed_as is a global thing and only really makes sense in a
> non-containerised system.  If the application is running within a
> memory cgroup then vm_enough_memory() and the global overcommit policy
> are at best irrelevant and misleading.
> 
> If use of vm_committed_as is indeed a bad thing, then exporting it to
> modules might increase the amount of badness in the kernel.
> 
> 
> I don't think these qualms are serious enough to stand in the way of
> this patch, but I'd be interested in hearing the memcg developers'
> thoughts on the matter?
> 
> 
> Perhaps you could provide a detailed description of why your module
> actually needs this?  Precisely what information is it looking for
> and why?  If we know that then perhaps a more comfortable alternative
> can be found.

The Hyper-V host has a policy engine for managing available physical memory across
competing virtual machines. This policy decision is based on a number of parameters
including the memory pressure reported by the guest. Currently, the pressure calculation is
based on the memory commitment made by the guest. From what I can tell, the ratio of
currently allocated physical memory to the current memory commitment made by the guest
(vm_committed_as) is used as one of the parameters in making the memory balancing decision on
the host. This is what Windows guests report to the host. So, I need some measure of memory
commitments made by the Linux guest. This is the reason I want export vm_committed_as. 

Regards,

K. Y  



