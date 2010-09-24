Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0IXMic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:38:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:28186 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab0IXMib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:38:31 -0400
Message-Id: <89kc63$i5oia2@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,229,1283756400"; 
   d="scan'208";a="610027842"
Date: Fri, 24 Sep 2010 13:38:27 +0100
To: Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] some clean up to intel-gtt.c
Cc: eric@anholt.net, linux-kernel@vger.kernel.org
References: <4C9CB4DA0200007800018CFE@vpn.id2.novell.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4C9CB4DA0200007800018CFE@vpn.id2.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 13:25:30 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
> In commit e517a5e97080bbe52857bd0d7df9b66602d53c4d the call to
> map_page_into_agp() got removed from intel_i830_setup_flush(), but the
> counterpart call from intel_i830_fini_flush() to unmap_page_from_agp()
> was left in place.

Thanks, those flags do look redundant. Applied to -next.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
