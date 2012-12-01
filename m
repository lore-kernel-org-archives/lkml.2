Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2LANlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 08:41:01 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53406 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2LANlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 08:41:00 -0500
MIME-Version: 1.0
In-Reply-To: <eeac1e$554nr0@AZSMGA002.ch.intel.com>
References: <CADDKRnDBHhqDzZVgB-8gv366OWKkamM9wR0+OcyfdX0kp_fKdA@mail.gmail.com>
	<eeac1e$554nr0@AZSMGA002.ch.intel.com>
Date: Sat, 1 Dec 2012 14:40:58 +0100
Message-ID: <CADDKRnBArtF3ObMODtz4iy7hi=e=Xq4sbG3Vos-Hpsz55S9ESQ@mail.gmail.com>
Subject: Re: [v3.7-rcx] drm/i915: *ERROR* Timed out waiting for forcewake old
 ack to clear
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, the path works.

Jörg


2012/11/27 Chris Wilson <chris@chris-wilson.co.uk>:
> On Tue, 27 Nov 2012 17:29:36 +0100, Jörg Otte <jrg.otte@gmail.com> wrote:
>> At boot-up with newer kernels (at least v3.6.x, v3.7-rc) I always see
>> following on the bootup-display:
>>
>> 3.7-rcx: [drm:__gen6_gt_force_wake_mt_get] *ERROR* Timed out waiting
>> for forcewake old ack to clear.
>> 3.6.x:    [drm:__gen6_gt_force_wake_mt_get] *ERROR* Force wake wait timed out
>
> This is harmless error, just reporting a one-time conflict with the
> state leftover by the BIOS. The fix is queued for 3.8.
>
> commit 16995a9fe140802c026c2ce17bf7e232f86d57ab
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Thu Oct 18 11:46:10 2012 +0100
>
>     drm/i915: Clear FORCEWAKE when taking over from BIOS
> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
