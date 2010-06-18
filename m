Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab0FRUmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:42:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59500 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0FRUme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:42:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s1KD+Mao4XWsGtXx3YKIQhLykDD68xNgV/hpjn0fPPooQUbCAmx0PZQ+Ejjru1YGF2
         zUXmgLr0iCdQvwc1c494rXJWvhls+EYXBPb9zKVGpJ31tt80Tc2L8W9uZ3rMeOnd2ApR
         OwqtnJKNFei3DxzsYHHc+cmrbwVP3ZnaT1YCo=
MIME-Version: 1.0
In-Reply-To: <201006182221.57333.rjw@sisk.pl>
References: <201006182221.57333.rjw@sisk.pl>
Date: Fri, 18 Jun 2010 22:42:32 +0200
Message-ID: <AANLkTim0QKSs9nrBnl847XhdM9YiKBEyNATPCscgcT5M@mail.gmail.com>
Subject: Re: [PATCH] DRM / radeon / PM: Do not evict VRAM during freeze phase 
	of hibernation
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel <dri-devel@lists.freedesktop.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/18 Rafael J. Wysocki <rjw@sisk.pl>:
> From: Rafael J. Wysocki <rjw@sisk.pl>

Thanks for you recent involvement in radeon driver! I can see you used
way shorter commit title this time ;) Just as a minor note, maybe you
could follow prefix-style we used to see around? Like simple
"drm/radeon/pm"? Or eventually something different instead of "pm" to
match difference between s/r and pm as engine/memory/voltage ops.

-- 
Greetings,
Rafał
