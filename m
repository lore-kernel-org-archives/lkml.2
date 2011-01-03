Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1ACTqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:46:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab1ACTqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:46:30 -0500
MIME-Version: 1.0
In-Reply-To: <4D22119B.9050007@t-online.de>
References: <4D21DC41.8070408@t-online.de> <b7da2f$q1ffv6@fmsmga001.fm.intel.com>
 <4D22119B.9050007@t-online.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Jan 2011 11:45:48 -0800
Message-ID: <AANLkTikffkQJnVKzcGhEZjPqg_iQPQ+P2Bbqz7A9Unq_@mail.gmail.com>
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, airlied@linux.ie, eric@anholt.net,
        jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 10:12 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
>
> I tried 2.6.37-rc8-git2 with both patches applied.

I thought Chris meant "instead of", rather than "both". Chris?

                Linus
