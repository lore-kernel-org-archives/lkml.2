Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0FNUVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:21:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:30461 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0FNUVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:21:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,416,1272870000"; 
   d="scan'208";a="526816509"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>
CC: Nils Carlson <nils.carlson@ludd.ltu.se>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Date: Mon, 14 Jun 2010 13:21:51 -0700
Subject: RE: Hardware Error Kernel Mini-Summit
Thread-Topic: Hardware Error Kernel Mini-Summit
Thread-Index: AcsL/TCZrwyCQawEQKSCPaNTPr3VwwAAVOLA
Message-ID: <987664A83D2D224EAE907B061CE93D530143FD9E73@orsmsx505.amr.corp.intel.com>
References: <1274204560.17703.82.camel@Joe-Laptop.home>
	<20100518185305.GA23921@elte.hu>
	<987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
	<20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org>
	<20100518222832.GJ22675@basil.fritz.box>	<m1wrv0zo9q.fsf@fess.ebiederm.org>
 <20100519064619.GA30320@aftab>	<20100519070919.GA9618@elte.hu>
	<50689ECC-A371-4923-BEBE-1A5A7E5B9D3B@ludd.ltu.se>
	<20100614114906.GG17092@basil.fritz.box> <m14oh59y58.fsf@fess.ebiederm.org>
In-Reply-To: <m14oh59y58.fsf@fess.ebiederm.org>
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

>- In practice it works even without silk screen labels.
>- The current EDAC code displays which DIMMS you have plugged
>  in so you can tell if you unplug one, if it was the DIMM
>  you were aiming at.

Potentially some unnecessary reboot cycles needed:
 - power off, pull a DIMM, power on, check with EDAC
 - repeat until you get the right DIMM

This also assumes that you can unplug just one DIMM. Some
motherboards require pairs of DIMMs to be added/removed together.

-Tony
