Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0LQAnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:43:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:46119 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab0LQAnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:43:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,358,1288594800"; 
   d="scan'208";a="869131262"
From: "Luck, Tony" <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Dec 2010 16:43:12 -0800
Subject: RE: linux-next: build warnings after merge of the ia64 tree
Thread-Topic: linux-next: build warnings after merge of the ia64 tree
Thread-Index: AcudgNNgYAzVxwvIRJ6CrgRDLIvv8wAAhgTQ
Message-ID: <987664A83D2D224EAE907B061CE93D530193D00A03@orsmsx505.amr.corp.intel.com>
References: <20101217112357.ec7879f1.sfr@canb.auug.org.au>
In-Reply-To: <20101217112357.ec7879f1.sfr@canb.auug.org.au>
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

> After merging the ia64 tree, today's linux-next build
> produced these warnings:

>drivers/acpi/apei/erst.c: In function 'erst_reader':
>drivers/acpi/apei/erst.c:826: warning: passing argument 1 of >'spinlock_check' from incompatible pointer type

Hmmmh. I wonder why I didn't see them in my build?

I'll take a look and try to fix it tomorrow.

Thanks for the notice.

-Tony

