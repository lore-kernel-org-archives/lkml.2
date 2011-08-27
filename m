Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab1H0NFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:05:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39810 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1H0NFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110826233028.074830de@sf.home>
References: <20110826233028.074830de@sf.home>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sat, 27 Aug 2011 10:04:43 -0300
Message-ID: <CAKi4VAKHR9EBTwwdmkzf=22LFvWr7L-xFwZ0=V=jB1iKY_+ekw@mail.gmail.com>
Subject: Re: i915: 3.1.0-rc3+: WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb8/0xf0()
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Fri, Aug 26, 2011 at 17:30, Sergei Trofimovich <slyich@gmail.com> wrote:
> Around -rc2+ i've noticed the following warning in dmesg [1]
>
>> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb8/0xf0()
>> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight'
>
> It tries to register backlight twice, so fails miserably.
> The machine is compaq-2510p with 965GM.
>
> Reverting commit aaa6fd2a004147bf32fce05720938236de3361d9 helps.
> ("Not all systems expose a firmware or platform mechanism for changing
> the backlight intensity on i915,  so add native driver support.")
>
> Attached dmesg before reverting the patch and after.
>

There's another patch that fixes this issue:

https://patchwork.kernel.org/patch/1086232/

regards,
Lucas De Marchi
