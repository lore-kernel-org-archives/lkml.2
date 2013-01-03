Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3ACVWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:22:37 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:62790 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3ACVWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:22:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130103204624.GA2533@fieldses.org>
References: <20130103204624.GA2533@fieldses.org>
Date: Thu, 3 Jan 2013 16:16:24 -0500
Message-ID: <CA+5PVA6PSsWGVAvSkdZXgoPaaroTuC0LvJ6-3mo1aU9LEUA1Sw@mail.gmail.com>
Subject: Re: "Hangcheck timer elapsed... GPU hung" in 3.8.0-rc2
From: Josh Boyer <jwboyer@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 3:46 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> I got a crash after a few minutes of running 3.8.0-rc2, was able to
> switch to a vt and look at dmesg:
>
>   [  490.962545] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>   [  490.963019] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
>   [  492.961446] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>   [  492.965613] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
>   [  492.965621] [drm:i915_reset] *ERROR* Failed to reset chip.
>
> Previously I was on 3.6.10-2.fc17.x86_64, which didn't have any such
> problem.

I'm not questioning that you haven't seen that error in F17, but we have
had quite a few bug reports with similar error messages for a while now.
Apparently there are lots of ways GPUs can get hung, so they might be
different from what you're seeing.  Just wanted to point out that it
might not be a new 3.8 change that caused it.

josh
