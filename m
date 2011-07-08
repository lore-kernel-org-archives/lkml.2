Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1GHWK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 18:10:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:3151 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1GHWK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 18:10:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,500,1304319600"; 
   d="scan'208";a="24656579"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>
CC: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jul 2011 15:10:26 -0700
Subject: RE: pstore dump inside an nmi handler
Thread-Topic: pstore dump inside an nmi handler
Thread-Index: Acw9uPbJv1+Gt4V9RkuSJICn0LzTrAAAnXXg
Message-ID: <987664A83D2D224EAE907B061CE93D5301E981ABAF@orsmsx505.amr.corp.intel.com>
References: <20110708201731.GA3025@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
 <20110708214941.GA20511@srcf.ucam.org>
In-Reply-To: <20110708214941.GA20511@srcf.ucam.org>
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

> EFI can't sleep (at least, not as far as the kernel's concerned), so 
> we're safe there. I think it's fair to assume atomicity here - crash 
> dumping is a pretty specific situation. Although we may need to think 
> about whether pstore should be saving reboot and poweroff in that case.

Hitachi engineers were very vocal about wanting the reboot/poweroff
logs (so they could deal with customers who accidentally rebooted the
wrong machine, and then denied doing so while also logging reports
that the victim machine had spontaneously reset).

-Tony
