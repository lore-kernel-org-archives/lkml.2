Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1FNKLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:11:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:55002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab1FNKLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:11:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,363,1304319600"; 
   d="scan'208";a="17978733"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "gregkh@suse.de" <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "a.miskiewicz@gmail.com" <a.miskiewicz@gmail.com>
Date: Tue, 14 Jun 2011 13:10:38 +0300
Subject: RE: [staging] staging/mei: fix suspend failure
Thread-Topic: [staging] staging/mei: fix suspend failure
Thread-Index: Acwpz1mzc1kiVqLJSL6f+r4Y4IchhAAq4Hdg
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401AD364297@hasmsx504.ger.corp.intel.com>
References: <1307972371-14815-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1307972371-14815-1-git-send-email-tomas.winkler@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Winkler, Tomas
> Sent: Monday, June 13, 2011 4:40 PM
> To: gregkh@suse.de; a.miskiewicz@gmail.com
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; Winkler,
> Tomas
> Subject: [staging] staging/mei: fix suspend failure
> 
> wait_event_interruptible_timeout return value was wrongly used.
> The remaining timeout was used as the error code.
> This fix translated wait_event_interruptible_timeout return value into error
> code that can be propagated.
> 
> [10291.674121] pci_pm_suspend(): mei_pci_suspend+0x0/0x8b [mei]
> returns 2500 It's thinkpad t400 with
> 00:03.0 Communication controller [0780]: Intel Corporation Mobile 4 Series
> Chipset MEI Controller [8086:2a44] (rev 07)
> 
> Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---


Greg,  I forgot to state that this one is probably 3.0 material.


Thanks
Tomas

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

