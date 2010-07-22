Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab0GWABW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 20:01:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:13444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab0GWABV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 20:01:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,245,1278313200"; 
   d="scan'208";a="588841710"
From: "Jin, Gordon" <gordon.jin@intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        Dave Airlie <airlied@redhat.com>
CC: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "eric@anholt.net" <eric@anholt.net>, Kees Cook <kees@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Fang, XunX" <xunx.fang@intel.com>
Date: Fri, 23 Jul 2010 07:59:20 +0800
Subject: RE: i915 boot regression on Q35 chipset with 2.6.35-rc4
Thread-Topic: i915 boot regression on Q35 chipset with 2.6.35-rc4
Thread-Index: Acso2e52zh72wWQ3TImAR3sFeyivKwApLQYQAB7Et1A=
Message-ID: <B32E3D5F1713054290B4FF257B89C51A1F1DAA51FD@shsmsx502.ccr.corp.intel.com>
References: <4C46E98A.3010206@mail.tpi.com>
 <8u3s94$g0j0tc@orsmga002.jf.intel.com> 
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

Jin, Gordon wrote on Thursday, July 22, 2010 5:19 PM:
> Chris Wilson wrote on Wednesday, July 21, 2010 9:37 PM:
>> On Wed, 21 Jul 2010 14:35:22 +0200, Tim Gardner <tcanonical@tpi.com>
>> wrote:
>>> What's up with this patch? I haven't received any comment, nor has
>>> it appeared in your git repository.
>> 
>> Dave hasn't taken it because it is a regression fix for i915 and the
>> current procedure is for those to go through Eric's tree. Eric has
>> been busy working on a new compiler for GLSL the last few weeks and
>> has been applying patches in batches.
>> 
>> The patch I am happy to ack, but since I introduced the regression
>> [https://bugzilla.kernel.org/show_bug.cgi?id=16294], I'd rather have
>> someone more familiar with the intricacies of G33/G35/Q35 review it.
>> 
>> For what is worth:
>> Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> This patch fixes the bug on our G33 (0x29b2).
> Tested-by: Xudong Hao <xudong.hao@intel.com>

Sorry, the pci id for above G33 is actually 0x29c2.

And we also validated the patch on Q35 (0x29b2):
Tested-by: Xun Fang <xunx.fang@intel.com>

-Gordon
