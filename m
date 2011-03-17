Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1CQXfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:35:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:34792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab1CQXf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="721388241"
From: "Luck, Tony" <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 17 Mar 2011 16:35:25 -0700
Subject: RE: linux-next: build failure in Linus' tree
Thread-Topic: linux-next: build failure in Linus' tree
Thread-Index: Acvk+5+2t68LLuLBTE2pjEj3BsOJVgAAA+oQ
Message-ID: <987664A83D2D224EAE907B061CE93D53019DCA3AD8@orsmsx505.amr.corp.intel.com>
References: <20110318102950.aee6f0bb.sfr@canb.auug.org.au>
In-Reply-To: <20110318102950.aee6f0bb.sfr@canb.auug.org.au>
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

>I have reverted the merge commit afe997a183ec ("Pull pstorev4 into
> release branch") for today.

Ok.  I'm working with Al on fixing the pstore code.  I have a patch
that makes it buildable - but there are many more changes needed to
cure the rest of the problems that Al pointed out.

-Tony
