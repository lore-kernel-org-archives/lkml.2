Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab1FWRM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:12:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:59764 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592Ab1FWRM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:12:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,414,1304319600"; 
   d="scan'208";a="19848978"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andi Kleen <andi@firstfloor.org>, Stefan Assmann <sassmann@kpanic.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "rick@vanrein.org" <rick@vanrein.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>
Date: Thu, 23 Jun 2011 10:12:55 -0700
Subject: RE: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Thread-Topic: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Thread-Index: Acwxxwe5bjalVaR9RpKUJORl0KkENwAAOpHQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
 <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de>
 <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de>
 <20110623170014.GN3263@one.firstfloor.org>
In-Reply-To: <20110623170014.GN3263@one.firstfloor.org>
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

> I don't think it makes sense to handle something like that with a list.
> The compact representation currently in badram is great for that.

I'd tend to agree here.  Rick has made a convincing argument that there
are significant numbers of real world cases where a defective row/column
in a DIMM results in a predictable pattern of errors.  The ball is now
in Google's court to take a look at their systems that have high numbers
of errors to see if they can actually be described by a small number
of BadRAM patterns as Rick has claimed.

-Tony
