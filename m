Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1GZHoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:44:39 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42684 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1GZHoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:44:34 -0400
MIME-Version: 1.0
X-Originating-IP: [212.120.32.74]
In-Reply-To: <1311662194-4050-5-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
	<1311662194-4050-5-git-send-email-keithp@keithp.com>
Date: Tue, 26 Jul 2011 09:44:32 +0200
X-Google-Sender-Auth: uxEaMtCYoW6oxvHeaRdxEhcDI4M
Message-ID: <CAKMK7uGHiXRU_3AqfOdLSmQsgMgf=Ah1_zf3k4T5E-7HC-f=Ng@mail.gmail.com>
Subject: Re: [PATCH 4/5] drm/i915: Delay 250ms before running the hotplug code
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue_delayed_work? Plays nicer with other workqueue-items.

-Daniel

PS: Scrap my other mail, just noticed that the merged patched r-b'ed
by Jesse uses the mode_config mutex.
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
