Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1ATXOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:14:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838Ab1ATXOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:14:37 -0500
Date: Thu, 20 Jan 2011 15:13:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ali Gholami Rudi <aliqrudi@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [Intel-gfx] [PATCH 2/5] i915: Add native backlight control
Message-Id: <20110120151349.49cf3ebb.akpm@linux-foundation.org>
In-Reply-To: <20112101004346@lilem.mirepesht>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com>
	<1295033065-13450-2-git-send-email-mjg@redhat.com>
	<20112101000015@lilem.mirepesht>
	<20112101004346@lilem.mirepesht>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 00:43:46 +0330
Ali Gholami Rudi <aliqrudi@gmail.com> wrote:

> Ali Gholami Rudi <aliqrudi@gmail.com> wrote:
> > I tried to apply this patch but I get:
> > 
> > 	drivers/gpu/drm/i915/intel_panel.c: In function 'intel_panel_setup_backlight':
> > 	drivers/gpu/drm/i915/intel_panel.c:319: error: 'struct backlight_properties' has no member named 'type'
> > 	drivers/gpu/drm/i915/intel_panel.c:319: error: 'BACKLIGHT_RAW' undeclared (first use in this function)
> > 	drivers/gpu/drm/i915/intel_panel.c:319: error: (Each undeclared identifier is reported only once
> > 	drivers/gpu/drm/i915/intel_panel.c:319: error: for each function it appears in.)
> 
> After applying patch 1/5, the patch applied cleanly.
> Now I can change the brightness using
> /sys/class/backlight/intel_backlight/brightness.
> So it does fix my issue.
> 

So we have a patch ordering issue and the
radeon-expose-backlight-class-device-for-legacy-lvds-encoder.patch
build error.

Matthew, I'll drop 'em all for now.
