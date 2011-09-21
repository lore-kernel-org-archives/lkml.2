Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1IUPmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:42:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:43245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab1IUPmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:42:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="51585857"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Han Pingtian <phan@redhat.com>, "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        edac-devel <linux-edac@vger.kernel.org>,
        Mark Grondona <mgrondona@llnl.gov>, Doug Thompson <norsk5@yahoo.com>
Date: Wed, 21 Sep 2011 08:41:58 -0700
Subject: RE: [PATCH v2] Fix EDAC sdram_scrub_rate read/write failure
Thread-Topic: [PATCH v2] Fix EDAC sdram_scrub_rate read/write failure
Thread-Index: Acx4WqdzA/wNiLZMS+qaFwQfxpf1UQAGjMdg
Message-ID: <987664A83D2D224EAE907B061CE93D5301EDED362C@orsmsx505.amr.corp.intel.com>
References: <20110916105856.GA13253@hpt.nay.redhat.com>
 <20110916125326.GA1957@gere.osrc.amd.com>
 <20110919073722.GE2822@hpt.nay.redhat.com> <20110919142055.GF7814@aftab>
 <987664A83D2D224EAE907B061CE93D5301EAB8A5C8@orsmsx505.amr.corp.intel.com>
 <20110921123313.GA29970@aftab>
In-Reply-To: <20110921123313.GA29970@aftab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: D4C0 E3n8 E5dO HGNS Ir1Y LKo0 PL6d S5Tl auRr oQ4C oxUv
 q2ln 2W0v 4fLI 7QCk
 7+lH;7;YgBwAEAAYQBtAGQANgA0AC4AbwByAGcAOwBsAGkAbgB1AHgALQBlAGQAYQBjAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQBjAGgAZQBoAGEAYgBAAHIAZQBkAGgAYQB0AC4AYwBvAG0AOwBtAGcAcgBvAG4AZABvAG4AYQBAAGwAbABuAGwALgBnAG8AdgA7AG4AbwByAHMAawA1AEAAeQBhAGgAbwBvAC4AYwBvAG0AOwBwAGgAYQBuAEAAcgBlAGQAaABhAHQALgBjAG8AbQA=;Sosha1_v1;7;{778E0338-E3D5-425A-B7BA-BA34759847A2};dABvAG4AeQAuAGwAdQBjAGsAQABpAG4AdABlAGwALgBjAG8AbQA=;Wed,
 21 Sep 2011 15:41:58
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAHYAMgBdACAARgBpAHgAIABFAEQAQQBDACAAcwBkAHIAYQBtAF8AcwBjAHIAdQBiAF8AcgBhAHQAZQAgAHIAZQBhAGQALwB3AHIAaQB0AGUAIABmAGEAaQBsAHUAcgBlAA==
x-cr-puzzleid: {778E0338-E3D5-425A-B7BA-BA34759847A2}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If scrub rate setting is not implemented, we say "No such device." and
> otherwise on error we say "Invalid argument" which should be clear,
> IMHO.

That sounds clear to me too.

-Tony
