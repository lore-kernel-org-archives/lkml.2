Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab2JZIFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:05:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51625 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab2JZIFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:05:09 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <508A1505.6010809@gmail.com>
References: <2b9aabdc-6f44-40cc-ad0b-4180101570c7@mail.android.htc.com>
	<5088CC9B.6010009@gmail.com>
	<CAKMK7uFMaf=ohEKyWKNsd-mSQkW__0BUww_iYLNFo347mEYAMg@mail.gmail.com>
	<84c8a8$68qvdl@orsmga001.jf.intel.com>
	<508A1505.6010809@gmail.com>
Date: Fri, 26 Oct 2012 10:05:07 +0200
X-Google-Sender-Auth: h-DIm0W5yZO1MXFjMDToqhHoyvs
Message-ID: <CAKMK7uHm8OXPGmYa3zgn64mmufgGMmqiAE=+5ugBBKQ+i6PTag@mail.gmail.com>
Subject: Re: [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
From: Daniel Vetter <daniel@ffwll.ch>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 6:43 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
>>
>> No worries, it is another ILK hang similar to the ones reported earlier
>> - it just seems the ring stops advancing. Hopefully it is a missing w/a
>> from http://cgit.freedesktop.org/~danvet/drm/log/?h=ilk-wa-pile
>> -Chris
>>
>
> well if this means building libdrm etc.. then thats not a problem, more time
> consuming if anything. perhaps an *.rpm that I can test to see?

It's not libdrm, the above is just a kernel git tree with a bunch of
ironlake workarounds.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
