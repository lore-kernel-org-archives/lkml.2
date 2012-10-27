Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab2J0N4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 09:56:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60080 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab2J0N4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 09:56:43 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <508AF938.9090004@gmail.com>
References: <2b9aabdc-6f44-40cc-ad0b-4180101570c7@mail.android.htc.com>
	<5088CC9B.6010009@gmail.com>
	<CAKMK7uFMaf=ohEKyWKNsd-mSQkW__0BUww_iYLNFo347mEYAMg@mail.gmail.com>
	<84c8a8$68qvdl@orsmga001.jf.intel.com>
	<508A1505.6010809@gmail.com>
	<CAKMK7uHm8OXPGmYa3zgn64mmufgGMmqiAE=+5ugBBKQ+i6PTag@mail.gmail.com>
	<508AF938.9090004@gmail.com>
Date: Sat, 27 Oct 2012 15:56:42 +0200
X-Google-Sender-Auth: HclDz571c1KzRa8Op4gkG-a5Fww
Message-ID: <CAKMK7uEa2fBVvxpwzomgWiZMZOU2O+v=EdL=w_HeccTsTag0-A@mail.gmail.com>
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

On Fri, Oct 26, 2012 at 10:57 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
>
> :~/drm> git clone git://people.freedesktop.org/~danvet/drm
> Cloning into 'drm'...
> remote: Counting objects: 2728390, done.
> remote: Compressing objects: 100% (418606/418606), done.
> remote: Total 2728390 (delta 2293727), reused 2717443 (delta 2282880)
> Receiving objects: 100% (2728390/2728390), 637.95 MiB | 599 KiB/s, done.
> Resolving deltas: 100% (2293727/2293727), done.
> warning: remote HEAD refers to nonexistent ref, unable to checkout.
>
>
> so now I have to go on a witch hunt for 600MB's in my system.

$ git checkout origin/ilk-wa-pile

... and you have the right branch checked out. No need for pitchforks
and witch hunts ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
