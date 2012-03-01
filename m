Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab2CASPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:15:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:58959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab2CASPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:15:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="116624879"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZUW7aAgAAO6gCAAAUXgIAACkUA//+aNaCAAJFAAP//fIVQgAG094CAAB6wgP//ywVw
Date: Thu, 1 Mar 2012 18:15:46 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F040AB7@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab>
 <4F4E3059.7040004@redhat.com> <20120229144054.GH21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com>
 <20120229171626.GJ21224@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040193@ORSMSX104.amr.corp.intel.com>
 <20120301112949.GA32410@aftab> <4F4F776B.90609@redhat.com>
In-Reply-To: <4F4F776B.90609@redhat.com>
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

> On all the above, the socket label starts on 1, but I bet we'll find cases
> where it start from 0.

Agreed. "Socket Designation" seems to be a free format string at the whim of
the board designer (and then interpreted and string filled in by a BIOS writer
with all the usual caveats that implies).

I suppose a smart reporting system would try to query this stuff ahead of
time to determine whether socket numbers were zero based, one based, or something
else altogether (Socket A, B, C ????)

-Tony
