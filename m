Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0KHSMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:12:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:3612 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab0KHSL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:11:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,169,1288594800"; 
   d="scan'208";a="675438157"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Nix <nix@esperi.org.uk>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Nov 2010 11:11:57 -0700
Subject: RE: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured by
 reboot)
Thread-Topic: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured
 by reboot)
Thread-Index: Act/Gyqx03bok3nzQQql23TBXObbawAVJlMg
Message-ID: <EA929A9653AAE14F841771FB1DE5A13660283A6815@rrsmsx501.amr.corp.intel.com>
References: <87ocaaszx1.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A136602815A3C7@rrsmsx501.amr.corp.intel.com>
	<87zktsskua.fsf@spindle.srvr.nix>	<1288837586.2835.3.camel@jbrandeb-mobl2>
 <87wrooi6qu.fsf@spindle.srvr.nix>
In-Reply-To: <87wrooi6qu.fsf@spindle.srvr.nix>
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

Nix wrote:
> On 4 Nov 2010, Jesse Brandeburg spake thusly:
>> The above could be responsible for your issue.  If you don't want to
>> disable ASPM system wide, then you could just make sure to run a
>> recent kernel with the ASPM patches, or get our e1000.sf.net e1000e
>> driver and try it, as it will work around the issue whether or not
>> aspm is enabled. 
> 
> For the record, cherry-picking
> ff10e13cd06f3dbe90e9fffc3c2dd2057a116e4b (the periodic
> phy-crash-and-reset check) atop 2.6.36 seems to have fixed it: at
> least, the machine has been up for a day now without trouble. This
> commit doesn't seem to be in Greg's stable-queue yet, but seems like
> a good candidate. 

This patch should have no effect on your issue if it is indeed ASPM related.
The ASPM issue can be intermittent and I have seen systems run for 3-5 days until the failure occurs, so one day doesn't necessarily rule it out.

BTW - what is the exact make/model of your system (dmidecode).

Thanks,
Emil
