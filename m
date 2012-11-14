Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422765Ab2KNMY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:24:29 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:1224 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161223Ab2KNMY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:24:27 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Joseph Gasparakis" <joseph.gasparakis@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>
Subject: RE: [PATCH 1/3] net: Add support for hardware-offloaded
 encapsulation
Thread-Topic: [PATCH 1/3] net: Add support for hardware-offloaded
 encapsulation
Thread-Index: AQHNvh+Txw513xb7fkuh1K7NvirtG5fpSRww
Date: Wed, 14 Nov 2012 12:23:57 +0000
Message-ID: <504C9EFCA2D0054393414C9CB605C37F1BF5CF01@SJEXCHMB06.corp.ad.broadcom.com>
References: <1352427483-4380-1-git-send-email-joseph.gasparakis@intel.com>
 <1352427483-4380-2-git-send-email-joseph.gasparakis@intel.com>
In-Reply-To: <1352427483-4380-2-git-send-email-joseph.gasparakis@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7CBD535F3R02306391-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Joseph Gasparakis
> Sent: Friday, November 09, 2012 4:18 AM
> To: davem@davemloft.net; shemminger@vyatta.com; chrisw@sous-sol.org
> Cc: Joseph Gasparakis; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Peter P Waskiewicz Jr
> Subject: [PATCH 1/3] net: Add support for hardware-offloaded encapsulation
> 
> This patch adds support in the kernel for offloading in the NIC Tx and Rx
> checksumming for encapsulated packets (such as VXLAN and IP GRE)
> 
> Signed-off-by: Joseph Gasparakis <joseph.gasparakis@intel.com>
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
[D.K.] 

>  	NETIF_F_HW_CSUM_BIT,		/* Can checksum all the packets.
> */
> +	NETIF_F_HW_CSUM_ENC_BIT,	/* Can checksum all inner headers */
>  	NETIF_F_IPV6_CSUM_BIT,		/* Can checksum TCP/UDP over
> IPV6 */

Also #define NETIF_F_HW_CSUM_ENC should be added


