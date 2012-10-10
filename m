Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2JJATF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:19:05 -0400
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.25]:40438
	"EHLO NA01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab2JJATC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:19:02 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2012 20:19:02 EDT
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -9
X-BigFish: PS-9(zz98dI9371I542M1432I1447Izz1202h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: RE: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Thread-Topic: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Thread-Index: AQHNpOUXgnwlsoeYd0afghaYt4KseJexY0uAgAACC0A=
Date: Wed, 10 Oct 2012 00:09:12 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930A33CC4@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-2-git-send-email-kys@microsoft.com>
 <20121009124449.f54bf8cb.akpm@linux-foundation.org>
In-Reply-To: <20121009124449.f54bf8cb.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.55.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51914002)(13464001)(51704002)(377454001)(24454001)(51856001)(47776002)(5343655001)(50466001)(74502001)(31966008)(8716001)(6806001)(46102001)(47446002)(74662001)(44976002)(20776001)(16696001)(47736001)(1076001)(47976001)(3846001)(2666001)(5343635001)(48376001)(16616001)(49866001)(16676001)(42186003)(306001)(33656001)(50986001)(4396001)(876001)(4196001)(5836001)(316001)(3746001)(37146003)(3556001);DIR:OUT;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0630013541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Tuesday, October 09, 2012 3:45 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org
> Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
> 
> On Sun,  7 Oct 2012 16:59:46 -0700
> "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> 
> > Add the basic balloon driver.
> 
> hm, how many balloon drivers does one kernel need?
> 
> Although I see that the great majority of this code is hypervisor-specific.
> 
> > Windows hosts dynamically manage the guest
> > memory allocation via a combination memory hot add and ballooning. Memory
> > hot add is used to grow the guest memory upto the maximum memory that can
> be
> > allocatted to the guest. Ballooning is used to both shrink as well as expand
> > up to the max memory. Supporting hot add needs additional support from the
> > host. We will support hot add when this support is available. For now,
> > by setting the VM startup memory to the VM  max memory, we can use
> > ballooning alone to dynamically manage memory allocation amongst
> > competing guests on a given host.
> >
> >
> > ...
> >
> > +static int  alloc_balloon_pages(struct hv_dynmem_device *dm, int
> num_pages,
> > +			 struct dm_balloon_response *bl_resp, int alloc_unit,
> > +			 bool *alloc_error)
> > +{
> > +	int i = 0;
> > +	struct page *pg;
> > +
> > +	if (num_pages < alloc_unit)
> > +		return 0;
> > +
> > +	for (i = 0; (i * alloc_unit) < num_pages; i++) {
> > +		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
> > +			PAGE_SIZE)
> > +			return i * alloc_unit;
> > +
> > +		pg = alloc_pages(GFP_HIGHUSER | __GFP_NORETRY |
> GFP_ATOMIC |
> > +				__GFP_NOMEMALLOC | __GFP_NOWARN,
> > +				get_order(alloc_unit << PAGE_SHIFT));
> 
> This choice of GFP flags is basically impossible to understand, so I
> suggest that a comment be added explaining it all.
> 
> I'm a bit surprised at the inclusion of GFP_ATOMIC as it will a) dip
> into page reserves, whcih might be undesirable and b) won't even
> reclaim clean pages, which seems desirable.  I suggest this also be
> covered in the forthcoming code comment.

I will rework these flags and add appropriate comments.

> 
> drivers/misc/vmw_balloon.c seems to me to have used better choices here.
> 
> > +		if (!pg) {
> > +			*alloc_error = true;
> > +			return i * alloc_unit;
> > +		}
> > +
> > +		totalram_pages -= alloc_unit;
> 
> Well, I'd consider totalram_pages to be an mm-private thing which drivers
> shouldn't muck with.  Why is this done?

By modifying the totalram_pages, the information presented in /proc/meminfo
correctly reflects what is currently assigned to the guest (MemTotal).
 
> 
> drivers/xen/balloon.c and drivers/virtio/virtio_balloon.c also alter
> totalram_pages, also without explaining why.
> drivers/misc/vmw_balloon.c does not.
> 
> > +		dm->num_pages_ballooned += alloc_unit;
> > +
> > +		bl_resp->range_count++;
> > +		bl_resp->range_array[i].finfo.start_page =
> > +			page_to_pfn(pg);
> > +		bl_resp->range_array[i].finfo.page_cnt = alloc_unit;
> > +		bl_resp->hdr.size += sizeof(union dm_mem_page_range);
> > +
> > +	}
> > +
> > +	return num_pages;
> > +}
> >
> > ...
> >
> 
> 
> 

Thanks for the prompt review. I will address your comments and repost the patches soon.
If it is ok with you, I am going to keep the code that manipulates totalram_pages 
(for reasons I listed above).

Regards,

K. Y

