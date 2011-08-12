Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1HLP6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:58:04 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50239 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1HLP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:58:01 -0400
Message-ID: <4E454D75.2090505@gmail.com>
Date: Fri, 12 Aug 2011 08:57:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@linux.ie
Subject: Re: i915 suspend crash: BUG: unable to handle kernel NULL pointer
 deferrence
References: <4E44C537.8040101@gmail.com> <yunobzusona.fsf@aiko.keithp.com>
In-Reply-To: <yunobzusona.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 07:14 AM, Keith Packard wrote:
> On Thu, 11 Aug 2011 23:16:23 -0700, "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> I can try for a bisect, but might not be able to do so due to time
>> constraints and things.
>> (if there is any patches to try and test let me know!)
>
> Can you provide the output of 'lspci -n -v', and can you tell us which
> version of the kernel this corresponds to?
>

yeah appologize for not posting any info on the machine(bit tired).
Anyways here is part of lspci(I can fpast the whole thing if need be),
and dmesg of the machine running the latest Mainline.

http://fpaste.org/aSQP/

one thing I am seeing is:


[ 96.384971] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0
[ 96.408364] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0
[ 96.425860] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0
[ 96.443365] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0
[ 96.474238] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0
[ 96.491728] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0
[ 96.521229] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0

in of which I have not seen in the past.

as for good kernel 2.6.39-rc5 survives suspend.

Justin P. Mattock
