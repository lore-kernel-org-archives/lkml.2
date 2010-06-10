Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab0FJPn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:43:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:64632 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758736Ab0FJPn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:43:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,398,1272870000"; 
   d="scan'208";a="806671591"
From: "Ronciak, John" <john.ronciak@intel.com>
To: "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Jun 2010 08:44:42 -0700
Subject: RE: [E1000-devel] e1000e probe failure on 2.6.34 and higher, Intel
 MB
Thread-Topic: [E1000-devel] e1000e probe failure on 2.6.34 and higher, Intel
 MB
Thread-Index: AcsIp/c490NURL8ZSUa6OBtk1YHnsAACyReA
Message-ID: <DDC57477F5D6F845A0DDCB99D3C4812D0CA6A93F56@orsmsx510.amr.corp.intel.com>
References: <4C10EFB6.3020500@canonical.com>
In-Reply-To: <4C10EFB6.3020500@canonical.com>
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

Tim,

> [   28.193628] e1000e 0000:00:19.0: PCI INT A disabled
> [   28.193740] e1000e: probe of 0000:00:19.0 failed with error -3
This looks like a BIOS problem.  It looks the interrupts aren't being setup correctly in the system and the driver can't request them.  Why it's working on some kernels and not others may be do to some BIOS setup with the interrupts that happens in one and not in the other.  Does the MB have the latest BIOS on it?  Please make sure and test it again if not.


Cheers,
John


