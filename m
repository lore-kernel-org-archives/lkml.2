Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0LQAu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:50:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:64055 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab0LQAuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,358,1288594800"; 
   d="scan'208";a="362906392"
From: "Luck, Tony" <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Dec 2010 16:50:14 -0800
Subject: RE: linux-next: build warnings after merge of the ia64 tree
Thread-Topic: linux-next: build warnings after merge of the ia64 tree
Thread-Index: AcudgNNgYAzVxwvIRJ6CrgRDLIvv8wAAhgTQAABGf9A=
Message-ID: <987664A83D2D224EAE907B061CE93D530193D00A15@orsmsx505.amr.corp.intel.com>
References: <20101217112357.ec7879f1.sfr@canb.auug.org.au> 
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

> Hmmmh. I wonder why I didn't see them in my build?

Ah - because I only built against Linus' tree, and linux-next
has:

commit 3b38bb5f7f06356a89bb2cbf92ad346025e95192
Author: Huang Ying <ying.huang@intel.com>
Date:   Thu Dec 2 10:40:53 2010 +0800

    ACPI, APEI, use raw spinlock in ERST

Drop the ia64/test branch if you like.

-Tony
