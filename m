Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2JRQqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:46:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:63568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab2JRQqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:46:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,608,1344236400"; 
   d="scan'208";a="229316633"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: Borislav Petkov <bp@alien8.de>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lcm@us.ibm.com" <lcm@us.ibm.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: RE: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Thread-Topic: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Thread-Index: AQHNkOH9ZFER3S2mLUqZGgg8EveT/JeVLvsAgCjRnACAAAfHAIAAHIQAgAAsK4CAAA6oAP//leQQgAFE6gCAAID/AP//wqmg
Date: Thu, 18 Oct 2012 16:46:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D51C7A@ORSMSX108.amr.corp.intel.com>
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
 <20120912122516.3825.87838.stgit@localhost.localdomain>
 <505C51D8.6070402@linux.vnet.ibm.com>
 <20121017105940.GA14590@x1.osrc.amd.com>
 <507E9622.6090606@linux.vnet.ibm.com>
 <20121017130934.GB14590@x1.osrc.amd.com>
 <507ED31B.7010402@linux.vnet.ibm.com>
 <20121017164006.GA14596@x1.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F19D517FF@ORSMSX108.amr.corp.intel.com>
 <507F96F2.9050305@linux.vnet.ibm.com>
 <20121018132456.GB6951@aftab.osrc.amd.com>
In-Reply-To: <20121018132456.GB6951@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @Tony: I'll send it upwards soonish in case there are no objections.
> This way no stable backport will be needed.

Acked-by: Tony Luck <tony.luck@intel.com>

