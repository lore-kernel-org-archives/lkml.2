Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1ATCNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 21:13:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400Ab1ATCNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 21:13:10 -0500
Date: Wed, 19 Jan 2011 18:12:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <daenzer@vmware.com>
Subject: Re: [PATCH 3/5] radeon: Expose backlight class device for legacy
 LVDS encoder
Message-Id: <20110119181213.8e301c33.akpm@linux-foundation.org>
In-Reply-To: <1295033065-13450-3-git-send-email-mjg@redhat.com>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com>
	<1295033065-13450-3-git-send-email-mjg@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011 14:24:23 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> From: Michel D__nzer <michel@daenzer.net>
> 
> Allows e.g. power management daemons to control the backlight level. Inspired
> by the corresponding code in radeonfb.
> 
> (Updated to add backlight type and make the connector the parent device - mjg)
> 

x86_64 allmodconfig:

drivers/gpu/drm/radeon/radeon_legacy_encoders.c: In function 'radeon_legacy_lvds_update':
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:64: error: 'struct radeon_encoder_atom_dig' has no member named 'bl_dev'
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:65: error: 'struct radeon_encoder_atom_dig' has no member named 'backlight_level'
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:69: error: 'struct radeon_encoder_lvds' has no member named 'bl_dev'
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:70: error: 'struct radeon_encoder_lvds' has no member named 'backlight_level'
drivers/gpu/drm/radeon/radeon_legacy_encoders.c: In function 'radeon_legacy_lvds_dpms':
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:144: error: 'struct radeon_encoder_atom_dig' has no member named 'dpms_mode'
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:147: error: 'struct radeon_encoder_lvds' has no member named 'dpms_mode'

