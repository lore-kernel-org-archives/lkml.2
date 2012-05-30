Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2E3Vv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:51:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43604 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab2E3Vvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:51:55 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120530213128.GA10407@redhat.com>
References: <20120530213128.GA10407@redhat.com>
Date: Wed, 30 May 2012 23:51:54 +0200
Message-ID: <CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com>
Subject: Re: Lots of i915/drm spew on 3.4
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:31 PM, Dave Jones <davej@redhat.com> wrote:
> On this hardware:
>
> 00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)
>
> I get this every boot with Linus current tree (up to af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76)

Just a quick question, is this a regression? If so, can you please
attach the output of xrandr --verbose from a noisy and a quite kernel
(otherwise just please attach it from this noisy kernel).

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
