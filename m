Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0EKWlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:41:01 -0400
Received: from mga06.intel.com ([134.134.136.21]:2411 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752839Ab0EKWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:40:58 -0400
Message-Id: <89khjo$fd48jf@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,210,1272870000"; 
   d="scan'208";a="517087855"
Date: Tue, 11 May 2010 23:40:41 +0100
To: Dave Airlie <airlied@gmail.com>
Subject: Re: DRM Error on Acer Aspire One
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       Ingo Molnar <mingo@elte.hu>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com> <89kc63$grtht6@fmsmga002.fm.intel.com> <20100511104818.8382a7de.akpm@linux-foundation.org> <89khjo$fd26d3@orsmga002.jf.intel.com> <20100511113555.a78c9c8e.akpm@linux-foundation.org> <89kc63$grv1m8@fmsmga002.fm.intel.com> <20100511121001.0731a9c2.akpm@linux-foundation.org> <89k77n$noi3t4@fmsmga001.fm.intel.com> <AANLkTikM916RlCBudL9_Pw--cpiu5mg_xcLFG9N1l9tL@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTikM916RlCBudL9_Pw--cpiu5mg_xcLFG9N1l9tL@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 08:22:49 +1000, Dave Airlie <airlied@gmail.com> wrote:
> I'd rather we just backout the hangcheck stuff touching copies at all
> at this point, and try again doing it properly with a slow work or
> something for later.

>From my point of view, the information provided by the hangcheck has been
invaluable for delving into and fixing some obnoxious driver bugs. I
suspect its honeymoon period is now over - those bugs that it could
detect easily have been fixed (I hope). In order to capture the relevant
information for later chipset generations, we will need to parse the
command stream and include auxiliary buffers. So whilst I would prefer to
see this in a release so that I can easily diagnose bug reports, I accept
that there is more work to be done and will HTFU.

-- 
Chris Wilson, Intel Open Source Technology Centre
