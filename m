Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1KILPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:15:23 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:58281 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab1KILPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:15:21 -0500
X-IronPort-AV: E=Sophos;i="4.69,483,1315180800"; 
   d="scan'208";a="8836956"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>
CC: "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Wed, 9 Nov 2011 11:15:10 +0000
Subject: RE: [PATCH 3/3] code clean up
Thread-Topic: [PATCH 3/3] code clean up
Thread-Index: Acyet93NDMFQL+dQRzyQps2PvQu7SwAGNNiw
Message-ID: <291EDFCB1E9E224A99088639C4762022B4543AB1BE@LONPMAILBOX01.citrite.net>
References: <4EBA35D3.3020506@oracle.com>
 <1320826574-29427-1-git-send-email-annie.li@oracle.com>
In-Reply-To: <1320826574-29427-1-git-send-email-annie.li@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annie,

  Why was this split out as a separate patch? Can it not be folded into patch 2 since the line it re-formats was introduced there?

  Paul

> -----Original Message-----
> From: annie.li@oracle.com [mailto:annie.li@oracle.com]
> Sent: 09 November 2011 08:16
> To: xen-devel@lists.xensource.com; linux-kernel@vger.kernel.org;
> konrad.wilk@oracle.com; jeremy@goop.org
> Cc: kurt.hackel@oracle.com; Paul Durrant; annie.li@oracle.com
> Subject: [PATCH 3/3] code clean up
> 
> From: Annie Li <annie.li@oracle.com>
> 
> Signed-off-by: Annie Li <annie.li@oracle.com>
> ---
>  drivers/xen/grant-table.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index a3294a26..458c00d 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -708,7 +708,8 @@ static void gnttab_request_version(void)  {
>  	int rc;
>  	struct gnttab_set_version gsv;
> -	const char *str = "we need grant tables version 2, but only
> version 1 is available\n";
> +	const char *str = "we need grant tables version 2, "
> +					"but only version 1 is
> available\n";
> 
>  	gsv.version = 2;
>  	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv,
> 1);
> --
> 1.7.6

