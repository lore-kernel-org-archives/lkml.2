Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030518Ab2HPW1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:27:48 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3104 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab2HPW1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:27:46 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Subject: RE: [PATCH] bnx2: turn off the network statck during
 initialization
From: "Michael Chan" <mchan@broadcom.com>
To: "Jiang Wang" <Jiang.Wang@riverbed.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chaitanya Lala" <Chaitanya.Lala@riverbed.com>,
        "Francis St. Amant" <Francis.St.Amant@riverbed.com>
In-Reply-To: <CEE05A0D7856E14880AD5560634EBEA834DB2C2B@SFO1EXC-MBXP06.nbttech.com>
References: <1345141295-7589-1-git-send-email-Jiang.Wang@riverbed.com>
 <1345143431.6916.36.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2ABC@SFO1EXC-MBXP06.nbttech.com>
 <1345145318.6916.42.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2B40@SFO1EXC-MBXP06.nbttech.com>
 <1345151593.6916.62.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CEE05A0D7856E14880AD5560634EBEA834DB2C2B@SFO1EXC-MBXP06.nbttech.com>
Date: Thu, 16 Aug 2012 15:27:39 -0700
Message-ID: <1345156059.6916.67.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7C33ACE749820255325-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 21:48 +0000, Jiang Wang wrote:
> ---- I see. I was confused by the name of bnx2_set_power_state()  and
> I think the PHY is actually powered up by bnx2_reset_nic, right?

bnx2_init_phy() in bnx2_init_nic() will bring up the PHY if it is down.

> 
> 


