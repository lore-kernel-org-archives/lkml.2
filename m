Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab1GKQew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:34:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:27917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082Ab1GKQev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:34:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,516,1304319600"; 
   d="scan'208";a="26356536"
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>
CC: linux-wimax <linux-wimax@intel.com>,
        "wimax@linuxwimax.org" <wimax@linuxwimax.org>
Date: Mon, 11 Jul 2011 09:33:58 -0700
Subject: RE: [PATCH 1/1] wimax: delete struct wimax_dev field rfkill_input
Thread-Topic: [PATCH 1/1] wimax: delete struct wimax_dev field rfkill_input
Thread-Index: Acw/c3cBCEg7Qnl+TXubTT0gJTWTWAAdN4Y6
Message-ID: <8F0C2E89B9AA20448D482EB589641EB3010264C7E2@orsmsx507.amr.corp.intel.com>
References: <1310350888180@xenotime.net>
In-Reply-To: <1310350888180@xenotime.net>
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


Hi Randy

>From: Randy Dunlap <rdunlap@xenotime.net>
>
> "make htmldocs" warns that struct member "rfkill_input" does not have
> a description.  After searching all kernel .[hc] files, this field
> is not used, so remove it.

Vitaly sent a patch a couple weeks ago to do this same cleanup.

Thank you anyway!
