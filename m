Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3AEFhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 00:37:05 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.24]:35349
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab3AEFhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 00:37:02 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "thozza@redhat.com" <thozza@redhat.com>
Subject: RE: [PATCH] tools: fix a typo in hv_set_ifconfig.sh
Thread-Topic: [PATCH] tools: fix a typo in hv_set_ifconfig.sh
Thread-Index: AQHN6wMmgVPSDMF32k6LMkqhHwiQ0Jg6Nk+g
Date: Sat, 5 Jan 2013 05:34:40 +0000
Message-ID: <02a1551e526646829ac1035ec73b9e85@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1357362186-5258-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1357362186-5258-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.156.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BL2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704002)(13464002)(16676001)(74662001)(54316002)(31966008)(49866001)(47736001)(50466001)(4396001)(47446002)(47976001)(74502001)(33646001)(59766001)(77982001)(5343655001)(6806001)(47776002)(51856001)(54356001)(5343635001)(50986001)(53806001)(56776001)(46406002)(46102001)(76482001)(23726001)(44976002)(56816002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB035;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0717E25089
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Saturday, January 05, 2013 12:03 AM
> To: gregkh@linuxfoundation.org; KY Srinivasan; Haiyang Zhang; linux-
> kernel@vger.kernel.org
> Cc: thozza@redhat.com; Jason Wang
> Subject: [PATCH] tools: fix a typo in hv_set_ifconfig.sh
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_set_ifconfig.sh |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
> index 3e9427e..daf7ec0 100755
> --- a/tools/hv/hv_set_ifconfig.sh
> +++ b/tools/hv/hv_set_ifconfig.sh
> @@ -65,4 +65,4 @@ cp $1 /etc/sysconfig/network-scripts/
>  interface=$(echo $1 | awk -F - '{ print $2 }')
> 
>  /sbin/ifdown $interface 2>/dev/null
> -/sbin/ifup $interfac 2>/dev/null
> +/sbin/ifup $interface 2>/dev/null
> --
> 1.7.1
> 
> 


