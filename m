Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0IEQYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:24:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:58000 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0IEQYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:24:11 -0400
Message-Id: <8u3s8d$jg1fmi@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,321,1280732400"; 
   d="scan'208";a="654360274"
Date: Sun, 05 Sep 2010 17:23:57 +0100
To: Pekka Enberg <penberg@kernel.org>, Sven Joachim <svenjoac@gmx.de>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
Cc: Hugh Dickins <hughd@google.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org> <89k83a$9hv9li@azsmga001.ch.intel.com> <AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com> <alpine.LSU.2.00.1009041244440.3044@sister.anvils> <87vd6ls0jd.fsf@turtle.gmx.de> <4C83C124.8050408@kernel.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4C83C124.8050408@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Sep 2010 19:11:16 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> Is someone picking this patch up or am I supposed to send it to Linus?

I have applied this patch to

http://cgit.freedesktop.org/~ickle/drm-intel/

Thanks.

-- 
Chris Wilson, Intel Open Source Technology Centre
