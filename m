Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2HXHMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:12:37 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39215 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2HXHMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:12:35 -0400
MIME-Version: 1.0
In-Reply-To: <87ehmwbw58.fsf@intel.com>
References: <20120824121955.454ebce22142f238f89c9a9a@canb.auug.org.au>
	<87ehmwbw58.fsf@intel.com>
Date: Fri, 24 Aug 2012 17:12:34 +1000
Message-ID: <CAPM=9twyQ_dFERy5DsBD60o1MZh=kZxpsgPV8J_zDWOo_Uj3bg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
From: Dave Airlie <airlied@gmail.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 5:13 PM, Jani Nikula <jani.nikula@intel.com> wrote:
> On Fri, 24 Aug 2012, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Dave,
>>
>> Today's linux-next merge of the drm tree got a conflict in
>> drivers/gpu/drm/i915/intel_modes.c between commit 4eab81366465
>> ("drm/i915: extract connector update from intel_ddc_get_modes() for
>> reuse") from Linus' tree and commit 451023dc32d4 ("drm: remove the
>> raw_edid field from struct drm_display_info") from the drm tree.
>
> Ugh, both from me, sorry about that. Wasn't sure when or in what order
> they'd go in.
>
>> I fixed it up (see below) and can carry the fix as necessary.
>
> I'm not quite sure what the patch below is against, but just removing
> the reference to raw_edid from a slightly different place is the way to
> go. Like you seem to do, so:
>
> Acked-by: Jani Nikula <jani.nikula@intel.com>
>
> I can also provide a patch against drm-next if needed.

That applied fine, I pulled it in for tomorrow -next.

Dave.
