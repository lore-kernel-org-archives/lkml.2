Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2K2RLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:11:30 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.28]:15273
	"EHLO NA01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab2K2RL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:11:29 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -7
X-BigFish: PS-7(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz6d524h8275bh8275dhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, Haiyang Zhang <haiyangz@microsoft.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] hv: hv_balloon: remove duplicated include from
 hv_balloon.c
Thread-Topic: [PATCH -next] hv: hv_balloon: remove duplicated include from
 hv_balloon.c
Thread-Index: AQHNzdiEl4Tq2123h0WTbffKwUKYjpgBC/LA
Date: Thu, 29 Nov 2012 17:08:53 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E5E809@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <CAPgLHd-9_p_haRkx-2D_5eT-E6_g84N=Hjs4JB5gu_kPVSp2Vw@mail.gmail.com>
In-Reply-To: <CAPgLHd-9_p_haRkx-2D_5eT-E6_g84N=Hjs4JB5gu_kPVSp2Vw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%TRENDMICRO.COM.CN$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464001)(377454001)(46406002)(47446002)(54356001)(50986001)(50466001)(74662001)(74502001)(44976002)(33656001)(53806001)(31966008)(47736001)(4396001)(47976001)(55846006)(51856001)(16676001)(6806001)(23726001)(49866001)(54316002)(56816002)(4477805001)(56776001)(47776002)(5343635001)(76482001)(5343655001)(46102001);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0680FADD48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> Sent: Wednesday, November 28, 2012 9:23 PM
> To: KY Srinivasan; Haiyang Zhang
> Cc: yongjun_wei@trendmicro.com.cn; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH -next] hv: hv_balloon: remove duplicated include from
> hv_balloon.c
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/hv/hv_balloon.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index f6c0011..0ce08c4 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -29,7 +29,6 @@
>  #include <linux/memory_hotplug.h>
>  #include <linux/memory.h>
>  #include <linux/notifier.h>
> -#include <linux/mman.h>
>  #include <linux/percpu_counter.h>
> 
>  #include <linux/hyperv.h>
> 
> 


