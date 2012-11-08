Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2KHWC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:02:59 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.23]:21647
	"EHLO na01-bl2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756595Ab2KHWC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:02:57 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.244.37;KIP:(null);UIP:(null);(null);H:CH1PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -4
X-BigFish: PS-4(zz98dI9371I542M1432Izz1de0h1202h1d1ah1d2ahzzz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
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
Thread-Index: AQHNpOUVxeGuP2ksmkqoWwiw1ukrt5eukjYAgAAumACAAKkDgIAB+liAgCbqv6CAA6TlAIAAA/OAgAAJiQCABK2ZcA==
Date: Thu, 8 Nov 2012 22:01:33 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E0D0CC@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-1-git-send-email-kys@microsoft.com>
 <20121008004358.GA12342@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF930A1FB31@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20121008133539.GA15490@kroah.com>
 <20121009124755.ce1087b4.akpm@linux-foundation.org>
 <426367E2313C2449837CD2DE46E7EAF930DF7FBB@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20121105134456.f655b85a.akpm@linux-foundation.org>
 <426367E2313C2449837CD2DE46E7EAF930DFA7B8@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <alpine.DEB.2.00.1211051418560.5296@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211051418560.5296@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
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
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(24454001)(377454001)(13464001)(46102001)(33656001)(16676001)(53806001)(74502001)(54356001)(51856001)(74662001)(23726001)(54316001)(47446002)(50466001)(46406002)(47976001)(6806001)(44976002)(47776002)(49866001)(50986001)(31966008)(4396001)(47736001)(76482001)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 06592CCE58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Monday, November 05, 2012 5:33 PM
> To: KY Srinivasan
> Cc: Andrew Morton; Greg KH; olaf@aepfle.de; linux-kernel@vger.kernel.org;
> andi@firstfloor.org; apw@canonical.com; devel@linuxdriverproject.org; linux-
> mm@kvack.org; Hiroyuki Kamezawa; Michal Hocko; Johannes Weiner; Ying Han
> Subject: RE: [PATCH 1/2] mm: Export vm_committed_as
> 
> On Mon, 5 Nov 2012, KY Srinivasan wrote:
> 
> > The Hyper-V host has a policy engine for managing available physical memory
> across
> > competing virtual machines. This policy decision is based on a number of
> parameters
> > including the memory pressure reported by the guest. Currently, the pressure
> calculation is
> > based on the memory commitment made by the guest. From what I can tell,
> the ratio of
> > currently allocated physical memory to the current memory commitment made
> by the guest
> > (vm_committed_as) is used as one of the parameters in making the memory
> balancing decision on
> > the host. This is what Windows guests report to the host. So, I need some
> measure of memory
> > commitments made by the Linux guest. This is the reason I want export
> vm_committed_as.
> >
> 
> I don't think you should export the symbol itself to modules but rather a
> helper function that returns s64 that just wraps
> percpu_counter_read_positive() which your driver could use instead.
> 
> (And why percpu_counter_read_positive() returns a signed type is a
> mystery.)

Yes, this makes sense. I just want to access (read) this metric. Andrew, if you are willing to
take this patch, I could send one.

Regards,

K. Y
 

