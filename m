Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1JSRIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:08:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:6038 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab1JSRIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:08:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,373,1315206000"; 
   d="scan'208";a="28198426"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, EDAC devel <linux-edac@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 19 Oct 2011 10:08:25 -0700
Subject: RE: [RFC -v2] x86 RAS: Reorganize functionality
Thread-Topic: [RFC -v2] x86 RAS: Reorganize functionality
Thread-Index: AcyObpcUZ5HJ+NltRP6a60qoEVuuEQAEnSyg
Message-ID: <987664A83D2D224EAE907B061CE93D5301F19DBD9F@orsmsx505.amr.corp.intel.com>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
In-Reply-To: <1319035866-29570-1-git-send-email-bp@amd64.org>
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

> and what I actually would like to see is something like

[ ] Reliability, Availability, Serviceability
[ ]  Machine Check Architecture
[ ]	Intel-specific features
	[ ] CMCI / overheating reporting
	[ ] MCE decoding
	[ ] MCE injection
[ ]	AMD-specific features
	[ ] Error thresholding
	[ ] MCE decoding
	[ ] MCE injection
[ ] ...

Where does EINJ and other APEI bits fit into this ... it isn't Intel
specific (Is it? Do AMD BIOS writers include it??). It would be nice
for it to eventually move in with the other "RAS" bit, rather than
being hidden under a couple of levels of ACPI menus.

-Tony
