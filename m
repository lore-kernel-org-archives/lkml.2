Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1HaWyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:54:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:38761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088Ab1HaWyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:54:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,309,1312182000"; 
   d="scan'208";a="47286390"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Wed, 31 Aug 2011 15:54:48 -0700
Subject: RE: [PATCH 0/5] Yet another pass at machine check recovery
Thread-Topic: [PATCH 0/5] Yet another pass at machine check recovery
Thread-Index: AcxoL0ebgPcqo7ZyRVG3VBiALM5oEwAARrQw
Message-ID: <987664A83D2D224EAE907B061CE93D5301EA7D992A@orsmsx505.amr.corp.intel.com>
References: <4e5eb3f12101199595@agluck-desktop.sc.intel.com>
 <72039.1314830494@turing-police.cc.vt.edu>
In-Reply-To: <72039.1314830494@turing-police.cc.vt.edu>
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

> Two slightly different versions showed up here almost on top of each other.
> Which one should we be looking at? Or do you want us to ignore both and you do
> another one with REPOST in the subject?

My script that added "in-reply-to" parts 1-5 to make them thread
from part 0 got a little over-enthusiastic and started recursing
on its own output.

The second version is identical (patchwise) to the first - it just
has a bogus "From: "Luck, Tony" line added.

I don't think I need to clutter the list with a repost.

Sorry for the noise and confusion - the bad script has been
told to go sit in the corner with a paper bag on its head.

-Tony

