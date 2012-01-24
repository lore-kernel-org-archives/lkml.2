Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2AXOvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:51:33 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46283 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2AXOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:51:32 -0500
Message-ID: <4F1EC56E.6040608@gmail.com>
Date: Tue, 24 Jan 2012 15:51:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120118 Thunderbird/10.0
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        daniel@ffwll.ch
Subject: new GPU hang [was: g33: GPU hangs]
References: <4ED7735A.1020903@suse.cz> <d08817$2d9rsk@azsmga001.ch.intel.com> <4F16917E.1090401@gmail.com> <20120118114308.GA4002@phenom.ffwll.local>
In-Reply-To: <20120118114308.GA4002@phenom.ffwll.local>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 12:43 PM, Daniel Vetter wrote:
>>> From 2b76187d2f5fc2352e391914b1828f91f93bb356 Mon Sep 17 00:00:00 2001
>>> From: Chris Wilson <chris@chris-wilson.co.uk>
>>> Date: Tue, 29 Nov 2011 15:12:16 +0000
>>> Subject: [PATCH] drm/i915: Only clear the GPU domains upon a successful
>>>  finish
>>
>> Hi, do you plan to push this patch upstream? Or am I supposed to not use
>> it anymore?
> 
> It's on track to get merged to drm-intel-next. I'll probably pick it up in a week
> or so.

OK, thanks.

Even though I use the patch, today another hang occurred:
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[drm] capturing error event; look for more information in
/debug/dri/0/i915_error_state
[drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting
910502 at 910475, next 910519)
[drm:i915_reset] *ERROR* Failed to reset chip.

I was cruising through a map at openstreetmaps.org. This was
3.2.0-next-20120118_64+. FWIW I updated to 3.3.0-rc1-next-20120124_64+
right now.

Is it related to the bug I reported at:
https://bugs.freedesktop.org/show_bug.cgi?id=43427
?

dmesg:
http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state.dmesg

error_state:
http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state

thanks,
-- 
js
