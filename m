Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162768Ab2GMNN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:13:59 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:28244
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800Ab2GMNN5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:13:57 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zzbb2dI9371I542M1432Izz1202hzz8275dhz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Greg KH <gregkh@suse.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Topic: 0xB16B00B5? Really? (was Re: Move hyperv out of the
 drivers/staging/ directory)
Thread-Index: AQHNYOGVQIU8WaEGMU+rzjsXSQqoHZcnLuVA
Date: Fri, 13 Jul 2012 13:13:42 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9223B57EC@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1316708240-25048-1-git-send-email-kys@microsoft.com>
 <20110922170450.GA4490@suse.de>
 <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110922173618.GA5624@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004170415.GA1320@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004193414.GA15672@suse.de> <4FFFF711.8040003@redhat.com>
In-Reply-To: <4FFFF711.8040003@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.179.128]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT001.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of Paolo
> Bonzini
> Sent: Friday, July 13, 2012 6:23 AM
> To: KY Srinivasan
> Cc: Greg KH; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> virtualization@lists.osdl.org
> Subject: 0xB16B00B5? Really? (was Re: Move hyperv out of the drivers/staging/
> directory)
> 
> Il 04/10/2011 21:34, Greg KH ha scritto:
> > diff --git a/drivers/staging/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> > similarity index 99%
> > rename from drivers/staging/hv/hyperv_vmbus.h
> > rename to drivers/hv/hyperv_vmbus.h
> > index 3d2d836..8261cb6 100644
> > --- a/drivers/staging/hv/hyperv_vmbus.h
> > +++ b/drivers/hv/hyperv_vmbus.h
> > @@ -28,8 +28,7 @@
> >  #include <linux/list.h>
> >  #include <asm/sync_bitops.h>
> >  #include <linux/atomic.h>
> > -
> > -#include "hyperv.h"
> > +#include <linux/hyperv.h>
> >
> >  /*
> >   * The below CPUID leaves are present if
> VersionAndFeatures.HypervisorPresent
> 
> git's rename detection snips away this gem:
> 
> +#define HV_LINUX_GUEST_ID_LO		0x00000000
> +#define HV_LINUX_GUEST_ID_HI		0xB16B00B5
> +#define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI
> << 32) | \
> +					   HV_LINUX_GUEST_ID_LO)
> 
> Somone was trying to be funny, I guess.
> 
> KY, I suppose you have access to Hyper-V code or can ask someone who does.
> Is this signature actually used in the Hyper-V host code?

It is still early in the morning here and pardon me if I am not seeing the issue.
Could you elaborate on what you want changed and why. This is a guest
signature that is stashed away in the hypervisor and perhaps can be retrieved
by the host. Other than that, this is not used anywhere else. MSFT has defined a
a namespace for guest IDs and while some ranges are reserved for MSFT operating
systems, there really is nothing special about the guest ID.

Regards,

K. Y



