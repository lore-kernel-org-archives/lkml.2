Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1DORz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:55:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:64323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab1DORz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:55:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,220,1301900400"; 
   d="scan'208";a="629364049"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
        Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Prarit Bhargava <prarit@redhat.com>, Russ Anderson <rja@sgi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 15 Apr 2011 10:55:24 -0700
Subject: RE: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
 errors
Thread-Topic: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
 errors
Thread-Index: Acv7Sb5+wp4M42bST86xiVWye1EbcgARSqewAACkfeA=
Message-ID: <987664A83D2D224EAE907B061CE93D5301A97B097C@orsmsx505.amr.corp.intel.com>
References: <1302857141-17580-1-git-send-email-bp@amd64.org>
 <66D9D2F0CDB5C9428E6166B01EC85EE162EF92B0F3@GVW0676EXC.americas.hpqcorp.net>
In-Reply-To: <66D9D2F0CDB5C9428E6166B01EC85EE162EF92B0F3@GVW0676EXC.americas.hpqcorp.net>
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

> Would it be okay to extend this reasoning and also remove the tainting 
> caused by TM1/TM2 thermal events:

Looks good to me - crossing a thermal threshold doesn't sound (by
itself) worthy of a TAINT.  Nothing has been corrupted.

Acked-by: Tony Luck <tony.luck@intel.com>
