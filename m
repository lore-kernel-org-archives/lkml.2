Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1JSRNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:13:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:19685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab1JSRNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,373,1315206000"; 
   d="scan'208";a="28200283"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, EDAC devel <linux-edac@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 19 Oct 2011 10:13:29 -0700
Subject: RE: [PATCH 2/9] x86, RAS: Start reorganizing RAS features support
Thread-Topic: [PATCH 2/9] x86, RAS: Start reorganizing RAS features support
Thread-Index: AcyObpfHLDO91B06QA+QaZy6KRLY2gAE1l1A
Message-ID: <987664A83D2D224EAE907B061CE93D5301F19DBDB5@orsmsx505.amr.corp.intel.com>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
 <1319035866-29570-3-git-send-email-bp@amd64.org>
In-Reply-To: <1319035866-29570-3-git-send-email-bp@amd64.org>
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

> Start relocating RAS features into a centralized location under
> arch/x86/kernel/cpu/ras/. Readjust Kconfig items and makefiles
> accordingly.

Not all ras features are "cpu" orientated ... should we really be
moving to "arch/x86/kernel/ras"?

-Tony
