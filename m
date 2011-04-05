Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1DEVSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:18:12 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59492 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab1DEVSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wov964UOFIAvEGn7zs7K+0OZ6DTz3x3n5ayRAjjdu7xIkg2UvKsCpIU5ZQ0M7wK8T7
         xNt1AXuNKXABOeqYKaHgyYXr3OIt4Ad919xseu08EZP7bE3C1NgPum5M/l5DuqJZTGMw
         1lLuZcTEHUFaWzBuSjiMEThqIbAss+ezaOklk=
MIME-Version: 1.0
In-Reply-To: <yunsjtwfo4l.fsf@aiko.keithp.com>
References: <yunsjtwfo4l.fsf@aiko.keithp.com>
Date: Wed, 6 Apr 2011 07:18:07 +1000
Message-ID: <BANLkTinw5+uOtmW9vagb1s_4UyNjDknMgQ@mail.gmail.com>
Subject: Re: i915 fixes for VGA and LVDS DDC probing
From: Dave Airlie <airlied@gmail.com>
To: Keith Packard <keithp@keithp.com>,
        "Torvalds, Linus" <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

can you pull these directly, as they are required for -rc2 and I'm
just adding latency.

Thanks,

Dave.

On Wed, Apr 6, 2011 at 6:18 AM, Keith Packard <keithp@keithp.com> wrote:
>
> Hi Dave,
>
> Please pull two fixes from
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6 drm-intel-fixes
>
> The first resolves a regression https://bugzilla.kernel.org/show_bug.cgi?id=32612
> with VGA detection.
>
> The second removes the same bogus code from the LVDS detection path.
>
> Changelog:
> ---------
>
> Chris Wilson (2):
>      drm/i915/crt: Remove 0xa0 probe for VGA
>      drm/i915/lvds: Remove 0xa0 DDC probe for LVDS
>
> Diffstat
> --------
>
>  intel_crt.c  |   20 --------------------
>  intel_lvds.c |   24 ------------------------
>  2 files changed, 44 deletions(-)
>
> --
> keith.packard@intel.com
>
