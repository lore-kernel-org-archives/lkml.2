Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab1H3Qke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:40:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:17038 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab1H3Qkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:40:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,302,1312182000"; 
   d="scan'208";a="12519938"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Huang, Ying" <ying.huang@intel.com>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Tue, 30 Aug 2011 09:40:30 -0700
Subject: RE: [RFC 1/2] ACPI, APEI, EINJ, Fix resource conflict on some
 machine
Thread-Topic: [RFC 1/2] ACPI, APEI, EINJ, Fix resource conflict on some
 machine
Thread-Index: Acxm3gruKnT8JcyMR5+q+/l/YjSkLQAVV8qQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301EA77924A@orsmsx505.amr.corp.intel.com>
References: <1314685709-7280-1-git-send-email-ying.huang@intel.com>
 <1314685709-7280-2-git-send-email-ying.huang@intel.com>
In-Reply-To: <1314685709-7280-2-git-send-email-ying.huang@intel.com>
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

>Some APEI firmware implementaiton will access injected address
>specified in param1 to trigger the error when injecting memory error.
>This will cause resource conflict with RAM.  So remove it from trigger
>table resources to avoid conflict.

Tested-by: Tony Luck <tony.luck@intel.com>
