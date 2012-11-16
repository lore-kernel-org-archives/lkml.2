Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2KPRte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:49:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59478 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2KPRtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:49:31 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CADnq5_NBz=Fk_n=Gkq9r9P6b+uq8c8MMVApjKdqhRrj44bgm7Q@mail.gmail.com>
References: <20121116171702.GB5854@phenom.ffwll.local>
	<CADnq5_NBz=Fk_n=Gkq9r9P6b+uq8c8MMVApjKdqhRrj44bgm7Q@mail.gmail.com>
Date: Fri, 16 Nov 2012 18:49:29 +0100
X-Google-Sender-Auth: JP7-VDYdg68hC67q25XJ7EOKRps
Message-ID: <CAKMK7uHeEgpEkzbbukz3fJ7rRm_18HyqjNDpspETDkrjMWd5cA@mail.gmail.com>
Subject: Re: [pull] drm-intel-next
From: Daniel Vetter <daniel@ffwll.ch>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 6:47 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> Hey, I don't see the drm HPD fixes.  Are you planning to put them in
> another pull request?  It would be nice to get them upstream for 3.8

Since they only refine the drm helpers in the core, I've figured
there's no need to merge them through the intel tree.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
