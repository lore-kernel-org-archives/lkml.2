Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221Ab2JYIsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:48:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:49777 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964801Ab2JYIsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:48:03 -0400
Message-Id: <84c8a8$68qvdl@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,646,1344236400"; 
   d="scan'208";a="210599349"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
To: Daniel Vetter <daniel@ffwll.ch>,
        "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CAKMK7uFMaf=ohEKyWKNsd-mSQkW__0BUww_iYLNFo347mEYAMg@mail.gmail.com>
References: <2b9aabdc-6f44-40cc-ad0b-4180101570c7@mail.android.htc.com> <5088CC9B.6010009@gmail.com> <CAKMK7uFMaf=ohEKyWKNsd-mSQkW__0BUww_iYLNFo347mEYAMg@mail.gmail.com>
Date: Thu, 25 Oct 2012 09:47:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012 10:16:08 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Thu, Oct 25, 2012 at 7:22 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
> >
> > here is a link to the file..: intel_error_decode
> > http://www.filefactory.com/file/22bypyjhs4mx
> 
> I haven't figured out how to access this thing. Can you please file a
> bug report on bugs.freedesktop.org and attach it there?

No worries, it is another ILK hang similar to the ones reported earlier
- it just seems the ring stops advancing. Hopefully it is a missing w/a
from http://cgit.freedesktop.org/~danvet/drm/log/?h=ilk-wa-pile
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
