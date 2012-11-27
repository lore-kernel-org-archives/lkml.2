Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2K0OKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:10:45 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:33889 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755490Ab2K0OKo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:10:44 -0500
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2fh2a8h683h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h15d0l1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 3/3] tools/hv: Fix permissions of created directory and
 files
Thread-Topic: [PATCH 3/3] tools/hv: Fix permissions of created directory and
 files
Thread-Index: AQHNzHTpc90wi29wpE6rVGhsOIrlvpf9tfYw
Date: Tue, 27 Nov 2012 13:59:52 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E5AC9B@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <426367E2313C2449837CD2DE46E7EAF930E5A96D@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <1354002994-2094-1-git-send-email-thozza@redhat.com>
 <1354002994-2094-3-git-send-email-thozza@redhat.com>
In-Reply-To: <1354002994-2094-3-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Tuesday, November 27, 2012 2:57 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; ben@decadent.org.uk
> Cc: Tomas Hozza
> Subject: [PATCH 3/3] tools/hv: Fix permissions of created directory and files
> 
> From: Ben Hutchings <ben@decadent.org.uk>
> 
> It's silly to create directories without execute permission, or to
> give permissions to 'other' but not the group-owner.
> 
> Write the permissions in octal and 'ls -l' format since these are much
> easier to read than the named macros.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_kvp_daemon.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index e266251..7105c7b 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -236,7 +236,7 @@ static int kvp_file_init(void)
>  	int alloc_unit = sizeof(struct kvp_record) * ENTRIES_PER_BLOCK;
> 
>  	if (access(KVP_CONFIG_LOC, F_OK)) {
> -		if (mkdir(KVP_CONFIG_LOC, S_IRUSR | S_IWUSR | S_IROTH)) {
> +		if (mkdir(KVP_CONFIG_LOC, 0755 /* rwxr-xr-x */)) {
>  			syslog(LOG_ERR, " Failed to create %s",
> KVP_CONFIG_LOC);
>  			exit(EXIT_FAILURE);
>  		}
> @@ -247,7 +247,7 @@ static int kvp_file_init(void)
>  		records_read = 0;
>  		num_blocks = 1;
>  		sprintf(fname, "%s/.kvp_pool_%d", KVP_CONFIG_LOC, i);
> -		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR |
> S_IROTH);
> +		fd = open(fname, O_RDWR | O_CREAT, 0644 /* rw-r--r-- */);
> 
>  		if (fd == -1)
>  			return 1;
> --
> 1.7.11.7
> 
> 



