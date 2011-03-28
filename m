Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1C1Sxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:53:35 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46176 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1C1Sxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D5xk3UULVbxPkMVL5ifD+AkHXFteYEKQ2kUV9Cp+24+KIhlEjZAw3HfWSVJ8HbsVHk
         a1DKr43lBUu1KGW2juPgWfq1eETBC8phWvzm0ZbDq0/VRI0YePHDibBS9mQ6MbETPse0
         9cDBwbbt9H4UhgtiYYBLw3LFWla+on+vKuy5Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=g27c3_Meu-YymXNPSD+isonN7CuWg78F9ZA+j@mail.gmail.com>
References: <alpine.DEB.2.00.1103241132001.12023@skynet.skynet.ie>
	<AANLkTi=g27c3_Meu-YymXNPSD+isonN7CuWg78F9ZA+j@mail.gmail.com>
Date: Mon, 28 Mar 2011 21:53:32 +0300
X-Google-Sender-Auth: q-L6FEjd_5jh1DO_Q74oTozZVb0
Message-ID: <AANLkTimAwNytQaykaMf33DUXcKOyGVWUetOAb_nf236t@mail.gmail.com>
Subject: Re: [git pull] drm fixes for -rc1
From: Pekka Enberg <penberg@kernel.org>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 9:43 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Thu, Mar 24, 2011 at 1:34 PM, Dave Airlie <airlied@linux.ie> wrote:
>> It should have the fix for your i915 in the intel patches, along with
>> a couple of radeon fixes, and the vblank change + fix.
>
> I'm seeing some laptop screen flicker during boot and a while after I
> log in (it then seems to go away). It's my trusty old Macbook with
> i915 and Ubuntu 10.04. I see this in dmesg:
>
> [    1.782046] [drm] initialized overlay support
> [    1.782075] [drm] capturing error event; look for more information
> in /debug/dri/0/i915_error_state
> [    1.782889] render error detected, EIR: 0x00000010
> [    1.782933] page table error
> [    1.782970]   PGTBL_ER: 0x00000102
> [    1.783009] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck:
> 0x00000010, masking
> [    1.783063] render error detected, EIR: 0x00000010
> [    1.783106] page table error
> [    1.783143]   PGTBL_ER: 0x00000102
>
> I'm attaching the full dmesg, i915_error_state, and .config.

I'm also seeing these errors now which seem to be new from 2.6.38-final:

[  437.566022] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
purgeable buffer
[  437.566187] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
purgeable buffer
[  437.566232] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
purgeable buffer
[  437.566275] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
purgeable buffer
[  437.566318] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
purgeable buffer
