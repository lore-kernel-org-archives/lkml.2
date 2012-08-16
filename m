Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030537Ab2HPWeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:34:24 -0400
Received: from eng.riverbed.com ([208.70.196.45]:29570 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424Ab2HPWeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:34:23 -0400
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Michael Chan <mchan@broadcom.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chaitanya Lala <Chaitanya.Lala@riverbed.com>,
        "Francis St. Amant" <Francis.St.Amant@riverbed.com>
Subject: RE: [PATCH] bnx2: turn off the network statck during initialization
Thread-Topic: [PATCH] bnx2: turn off the network statck during initialization
Thread-Index: AQHNe9wN/GY2GzvEwk20Q1fuXq+2eJddP4KA//+NcgCAAHtYAP//kWDwgACL2ID//48v0AAQs62AAA55TsA=
Date: Thu, 16 Aug 2012 22:34:21 +0000
Message-ID: <CEE05A0D7856E14880AD5560634EBEA834DB2CA2@SFO1EXC-MBXP06.nbttech.com>
References: <1345141295-7589-1-git-send-email-Jiang.Wang@riverbed.com>
 <1345143431.6916.36.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2ABC@SFO1EXC-MBXP06.nbttech.com>
 <1345145318.6916.42.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2B40@SFO1EXC-MBXP06.nbttech.com>
 <1345151593.6916.62.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2C2B@SFO1EXC-MBXP06.nbttech.com>
 <1345156059.6916.67.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
In-Reply-To: <1345156059.6916.67.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.254]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got it. Thank you very much.

Regards,

Jiang

-------------------------------------
Jiang Wang
Member of Technical Staff
Riverbed Technology
Tel: (408) 522-5109
Email: Jiang.Wang@riverbed.com
www.riverbed.com


-----Original Message-----
From: Michael Chan [mailto:mchan@broadcom.com] 
Sent: Thursday, August 16, 2012 3:28 PM
To: Jiang Wang
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Chaitanya Lala; Francis St. Amant
Subject: RE: [PATCH] bnx2: turn off the network statck during initialization

On Thu, 2012-08-16 at 21:48 +0000, Jiang Wang wrote:
> ---- I see. I was confused by the name of bnx2_set_power_state()  and 
> I think the PHY is actually powered up by bnx2_reset_nic, right?

bnx2_init_phy() in bnx2_init_nic() will bring up the PHY if it is down.

> 
> 


