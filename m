Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2C1Swg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:52:36 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:54122 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932551Ab2C1Swf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:52:35 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 5/7 v6] drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332959199-32161-6-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org> <1332959199-32161-6-git-send-email-djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 19:52:16 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332960747_131180@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 02:26:37 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> It is very common for an i2c device to require a small 1 or 2 byte write
> followed by a read.  For example, when reading from an i2c EEPROM it is
> common to write and address, offset or index followed by a reading some
> values.

Hmm, I have

"gmbus1, bits 8-15: 8-bit GMBUS slave register
This field is redundant and should not be used."

Scary. :)

Otherwise, the code itself looks correct and quite neatly done now.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
