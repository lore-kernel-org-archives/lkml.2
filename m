Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2CAS6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:58:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:63538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab2CAS6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:58:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131845988"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZUW7aAgAAO6gCAAAUXgIAACkUA//+aNaCAAJFAAP//fIVQgAG094CAAB6wgP//ywVwABIC5AAAEKe6EA==
Date: Thu, 1 Mar 2012 18:58:31 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F040B18@ORSMSX104.amr.corp.intel.com>
References: <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab>
 <4F4E3059.7040004@redhat.com> <20120229144054.GH21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com>
 <20120229171626.GJ21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040193@ORSMSX104.amr.corp.intel.com>
 <20120301112949.GA32410@aftab> <4F4F776B.90609@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F040AB7@ORSMSX104.amr.corp.intel.com>
 <20120301184544.GA3391@aftab>
In-Reply-To: <20120301184544.GA3391@aftab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Query from where? (And pls don't tell me DMI tables. :-))

Sorry - but DMI is all we've got.  We need to start using it, and have
people report bugs when it is wrong. Then it might get better. Linux
has had some success in shaming BIOS writers with:

 printk("Your BIOS is buggy ...")

Our biggest problem here is the life-cycle ... by the time Linux
users start seeing these problems, the BIOS people have already
moved on to the next generation system.

BUT - if Linux wants to play in RAS space - we need this to be
right - and to do that we need SMBIOS (DMI) bugs to be regarded as
priority #1.

-Tony
