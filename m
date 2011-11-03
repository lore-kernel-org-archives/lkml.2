Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab1KCQbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:31:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:60408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933827Ab1KCQbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="70861419"
From: "Luck, Tony" <tony.luck@intel.com>
To: Josh Boyer <jwboyer@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 3 Nov 2011 09:31:32 -0700
Subject: RE: sb_edac 32-bit compile fail due to 64-bit divide
Thread-Topic: sb_edac 32-bit compile fail due to 64-bit divide
Thread-Index: AcyaNwIT9MrkD9P3RBeHqXuJ0aTgvgADnKmg
Message-ID: <987664A83D2D224EAE907B061CE93D5301F566BB32@orsmsx505.amr.corp.intel.com>
References: <20111103140716.GF19809@zod.bos.redhat.com>
 <4EB2A5FF.1040808@redhat.com> <20111103144347.GG19809@zod.bos.redhat.com>
In-Reply-To: <20111103144347.GG19809@zod.bos.redhat.com>
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

>> Of course, an interim fix would be to make it depend on CONFIG_64BIT or CONFIG_X86_64.
>
> That would work I guess.  It's up to you.

Typically the test platforms I get have pretty much the minimum sane memory
configuration - my Sandy Bridge EP machine came with 32GB of memory (which
is theoretically bootable with a 32-bit kernel, but really isn't going to
be much fun to use).  So I would think that time could be spent on more
productive things than making this edac driver work on 32-bit.  My vote
is for the "depends on 64-bit" solution.

-Tony
