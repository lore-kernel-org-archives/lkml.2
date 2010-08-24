Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0HXIug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:50:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:48753 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab0HXIue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:50:34 -0400
Message-Id: <89kc63$hrqmar@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,262,1280732400"; 
   d="scan'208";a="599611739"
Date: Tue, 24 Aug 2010 09:50:29 +0100
To: Ivan Bulatovic <combuster@gmx.com>
Subject: Re: i915: 2.6.36-rc2 wrong resolution on gdm start
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, eric@anholt.net
References: <1282611655.2177.19.camel@localhost.localdomain> <8u3s8d$jcftu0@orsmga001.jf.intel.com> <1282638912.2191.17.camel@localhost.localdomain>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1282638912.2191.17.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 10:35:12 +0200, Ivan Bulatovic <combuster@gmx.com> wrote:
> Above patches didn't help when applied to 2.6.36-rc2. 

Would be useful to double check reverting the bad commit helps.
 
> I'm going to compare dmesg between 2.6.35.3 and 2.6.36-rc2 with
> drm.debug=0x6. Thanks,

Aye that would be a useful check.

-- 
Chris Wilson, Intel Open Source Technology Centre
