Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2EOGTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:19:40 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:64196 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752548Ab2EOGTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:19:39 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/1] drivers/gpu/drm/i915: Fixed uninitialized variables (warnings).
To: Raphael Carvalho <rsc.utroz@gmail.com>, keithp@keithp.com,
        airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAC+pAyfw5UFnuLyrpN5D2r9J=PijtgrdwJUmMh3xthM3Rx-Zvw@mail.gmail.com>
References: <CAC+pAyfw5UFnuLyrpN5D2r9J=PijtgrdwJUmMh3xthM3Rx-Zvw@mail.gmail.com>
Date: Tue, 15 May 2012 07:19:30 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1337062773_35388@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 20:57:07 -0300, Raphael Carvalho <rsc.utroz@gmail.com> wrote:
> From 1e77059e8f3158fd4844e3f6a5466a063d2f407e Mon Sep 17 00:00:00 2001
> From: "Raphael S.Carvalho" <utroz@oakcoders.com>
> Date: Mon, 14 May 2012 20:19:24 -0300
> Subject: [PATCH 1/1]     drivers/gpu/drm/i915: Fixed uninitialized
>  variables (warnings).
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> As you see, this modifications were really very important because if the
> remain variable receives a value lower or equals than 0 from the args->size
> variable, indeed, a bad behavior could ocurrs.

Which is checked for before calling the function. Look harder at what
gcc is trying to tell you, the actual location of gcc's error is inside
an inlined function...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
