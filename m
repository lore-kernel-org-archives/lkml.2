Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0KJTPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:15:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:16537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab0KJTPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:15:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,179,1288594800"; 
   d="scan'208";a="347115128"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 10 Nov 2010 11:15:48 -0800
Subject: RE: [PATCH 01/12] EDAC, MCE: Select extended error code mask
Thread-Topic: [PATCH 01/12] EDAC, MCE: Select extended error code mask
Thread-Index: AcuBCgZT2wME6srLRHaYBMdVrkiTtAAAQj0QAAAd0WA=
Message-ID: <987664A83D2D224EAE907B061CE93D5301649A708E@orsmsx505.amr.corp.intel.com>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
 <1289415741-15000-2-git-send-email-bp@amd64.org>
 <987664A83D2D224EAE907B061CE93D5301649A7081@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301649A7081@orsmsx505.amr.corp.intel.com>
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

> (MCi_STATUS[20:16]). Add a mask variable which default 0xf is overridden
> on F15h.

I failed to read the "overridden" part ...
Ignore the noise - I blame the cold medication I'm taking.

-Tony
