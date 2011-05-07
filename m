Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab1EGEh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 00:37:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:22906 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab1EGEhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 00:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,329,1301900400"; 
   d="scan'208";a="639303814"
From: "Wu, Xia" <xia.wu@intel.com>
To: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 7 May 2011 12:37:15 +0800
Subject: How to disable TCP checksum calculation?
Thread-Topic: How to disable TCP checksum calculation?
Thread-Index: AcwMcHDNUhqI81jKQziIYWUGg6hevQ==
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF35079BA24F@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {D06276FD-F372-4483-8FAB-615BC9198890}
x-cr-hashedpuzzle: BvND B8Eh CnKx C3l1 HKZu Hf6J NSh5 OSOR PXs3 Pmqs SxNS
 UAPS U/Ni Vqp4 Za8N
 dXgL;3;YQBsAGEAbgBAAGwAeABvAHIAZwB1AGsALgB1AGsAdQB1AC4AbwByAGcALgB1AGsAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AdwBpAHIAZQBsAGUAcwBzAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{D06276FD-F372-4483-8FAB-615BC9198890};eABpAGEALgB3AHUAQABpAG4AdABlAGwALgBjAG8AbQA=;Sat,
 07 May 2011 04:37:15
 GMT;SABvAHcAIAB0AG8AIABkAGkAcwBhAGIAbABlACAAVABDAFAAIABjAGgAZQBjAGsAcwB1AG0AIABjAGEAbABjAHUAbABhAHQAaQBvAG4APwA=
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, ALL,
I'm studying TCP transporting efficiency. Now I want to disable TCP checksum calculation, but I cannot find the right way to disable it. Who can give me a help on how to disable TCP checksum on Linux?

Thanks
xia 
