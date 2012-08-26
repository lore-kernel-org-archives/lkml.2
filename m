Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab2HZTSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 15:18:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39415 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2HZTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 15:18:07 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120826183952.GB5194@phenom.ffwll.local>
References: <1345846584-5910-1-git-send-email-sedat.dilek@gmail.com>
	<1345846584-5910-2-git-send-email-sedat.dilek@gmail.com>
	<20120826183952.GB5194@phenom.ffwll.local>
Date: Sun, 26 Aug 2012 21:18:05 +0200
Message-ID: <CA+icZUUzoPQEogUAcCrEiW054MwqB6Y3kf_vaYF8-+SgYorPZA@mail.gmail.com>
Subject: Re: [PATCH drm-next 2/3] drm/i915: Remove reference to
 drm_display_info raw_edid field
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Sedat Dilek <sedat.dilek@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 8:39 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sat, Aug 25, 2012 at 12:16:23AM +0200, Sedat Dilek wrote:
>> Reported-By: Stephen Rothwell <sfr@canb.auug.org.au>
>> Acked-by: Jani Nikula <jani.nikula@intel.com>
>> Acked-by: Dave Airlie <airlied@gmail.com>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> This doesn't apply to my drm-intel-next tree any more - we've moved around
> the assignement a bit.

Error still exists but is in intel_ddc_get_modes() now.

- Sedat -

http://cgit.freedesktop.org/~danvet/drm-intel/tree/drivers/gpu/drm/i915/intel_modes.c?h=drm-intel-next#n53

> -Daniel
>
>> ---
>>  drivers/gpu/drm/i915/intel_modes.c |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
>> index 29b7259..4bc1c0f 100644
>> --- a/drivers/gpu/drm/i915/intel_modes.c
>> +++ b/drivers/gpu/drm/i915/intel_modes.c
>> @@ -45,7 +45,6 @@ int intel_connector_update_modes(struct drm_connector *connector,
>>       drm_mode_connector_update_edid_property(connector, edid);
>>       ret = drm_add_edid_modes(connector, edid);
>>       drm_edid_to_eld(connector, edid);
>> -     connector->display_info.raw_edid = NULL;
>>       kfree(edid);
>>
>>       return ret;
>> --
>> 1.7.9.5
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
