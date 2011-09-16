Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1IPOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:16:56 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:48731 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1IPOQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:16:54 -0400
Date: Fri, 16 Sep 2011 16:17:19 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        "Clark, Rob" <rob@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20110916141719.GD2873@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
	linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
	"Clark, Rob" <rob@ti.com>
References: <1316088425.11294.78.camel@lappyti>
 <yunboul7sx7.fsf@aiko.keithp.com>
 <1316100594.23214.65.camel@deskari>
 <yun8vpp7qk7.fsf@aiko.keithp.com>
 <1316107275.23214.99.camel@deskari>
 <yunfwjxwbjq.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunfwjxwbjq.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 07:55:37PM -0500, Keith Packard wrote:
> I suspect helper functions would be a good model to follow, rather than
> trying to create a whole new device infrastructure; some of the
> communication paths aren't easily separable from the underlying output
> devices.

This. Helper functions make the driver writers life so much easier - if
your hw doesn't quite fit the model, you can usually extend functionality
with much less fuzz than if there's a full framework. This is also pretty
much the reason, why I don't like ttm.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
