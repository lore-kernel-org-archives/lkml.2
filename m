Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2KIP5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:57:36 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.23]:20914
	"EHLO na01-bl2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752680Ab2KIP5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:57:34 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.244.37;KIP:(null);UIP:(null);(null);H:CH1PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 2/3] tools/hv: Fix string types
Thread-Topic: [PATCH 2/3] tools/hv: Fix string types
Thread-Index: AQHNvoOmdgMJow77AU+QIOy+me1OuJfhqJ3A
Date: Fri, 9 Nov 2012 15:56:58 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E2236E@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <1352469681-4432-1-git-send-email-thozza@redhat.com>
 <1352469681-4432-2-git-send-email-thozza@redhat.com>
In-Reply-To: <1352469681-4432-2-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.192.70.131]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464001)(51704002)(377454001)(74502001)(51856001)(44976002)(4396001)(6806001)(74662001)(47776002)(47736001)(47446002)(54356001)(16676001)(47976001)(76482001)(5343635001)(33656001)(49866001)(50466001)(46102001)(46406002)(53806001)(54316001)(23726001)(31966008)(50986001)(55846005);DIR:OUT;SFP:;LANG:;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 06607E485E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Friday, November 09, 2012 9:01 AM
> To: olaf@aepfle.de; KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; apw@canonical.com;
> jasowang@redhat.com; ben@decadent.org.uk
> Cc: Tomas Hozza
> Subject: [PATCH 2/3] tools/hv: Fix string types
> 
> Initial patch by Ben Hutchings <ben@decadent.org.uk>
> 
> Standard C strings are arrays of char, not __u8 (unsigned char).
> Declare variables and parameters accordingly, and add the necessary
> casts.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index d9b3a74..573b9aa 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -300,7 +300,7 @@ static int kvp_file_init(void)
>  	return 0;
>  }
> 
> -static int kvp_key_delete(int pool, __u8 *key, int key_size)
> +static int kvp_key_delete(int pool, const char *key, int key_size)
>  {
>  	int i;
>  	int j, k;
> @@ -343,7 +343,7 @@ static int kvp_key_delete(int pool, __u8 *key, int
> key_size)
>  	return 1;
>  }
> 
> -static int kvp_key_add_or_modify(int pool, __u8 *key, int key_size, __u8
> *value,
> +static int kvp_key_add_or_modify(int pool, const char *key, int key_size, const
> char *value,
>  			int value_size)
>  {
>  	int i;
> @@ -397,7 +397,7 @@ static int kvp_key_add_or_modify(int pool, __u8 *key, int
> key_size, __u8 *value,
>  	return 0;
>  }
> 
> -static int kvp_get_value(int pool, __u8 *key, int key_size, __u8 *value,
> +static int kvp_get_value(int pool, const char *key, int key_size, char *value,
>  			int value_size)
>  {
>  	int i;
> @@ -429,8 +429,8 @@ static int kvp_get_value(int pool, __u8 *key, int key_size,
> __u8 *value,
>  	return 1;
>  }
> 
> -static int kvp_pool_enumerate(int pool, int index, __u8 *key, int key_size,
> -				__u8 *value, int value_size)
> +static int kvp_pool_enumerate(int pool, int index, char *key, int key_size,
> +				char *value, int value_size)
>  {
>  	struct kvp_record *record;
> 
> --
> 1.7.11.7
> 
> 


