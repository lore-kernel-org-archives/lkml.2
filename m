Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1AJRf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:35:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:50757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab1AJRfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:35:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,302,1291622400"; 
   d="scan'208";a="695339145"
From: "Luck, Tony" <tony.luck@intel.com>
To: Pavel Machek <pavel@ucw.cz>, Marco Stornelli <marco.stornelli@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Date: Mon, 10 Jan 2011 09:35:53 -0800
Subject: RE: [PATCH 01/17] pramfs: documentation
Thread-Topic: [PATCH 01/17] pramfs: documentation
Thread-Index: AcuwnelEVql8tz1NSdCZLyCFjUr2FwATb0UQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301940801B2@orsmsx505.amr.corp.intel.com>
References: <4D25AF02.60208@gmail.com>
 <AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com>
 <4D2777FC.6040509@gmail.com>
 <AANLkTimtvYfHXG=rMLbFLzVaKbfB6nrj_ZE1AH4quRG2@mail.gmail.com>
 <4D281D65.1070102@gmail.com>
 <20110110080839.GA16066@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20110110080839.GA16066@atrey.karlin.mff.cuni.cz>
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

> You'd be better running ext2 over special block device,
> it is quite simple.

Marco,

You might want to spend some more time answering this question
(it is a particularly good one).  What are the reasons to use
pramfs, rather than a ext2 over a mem<->block driver.  You covered
some in your part 0 patch (like ext2 wastes time getting optimal
block placement for rotating media). But it might be a good idea
to go back over them here.  From my (lightweight) reading of your
code, it looks like the biggest benefit is avoiding duplicating
the data in the pramfs memory region and the VM page cache ...
which is a big deal for your target audience of hand held devices
where memory is a somewhat scarce resource. But you probably
have other goodness in there too.

-Tony
