Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab2LTVNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:13:38 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59670 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LTVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:13:30 -0500
X-Greylist: delayed 95570 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 16:13:30 EST
Date: Thu, 20 Dec 2012 13:13:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, Roland Stigge <stigge@antcom.de>,
        linux-doc@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Felipe Balbi <balbi@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] RFC: input: Extend matrix-keypad device tree binding
Message-ID: <20121220211323.GA24981@core.coreip.homeip.net>
References: <1356035039-21653-1-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356035039-21653-1-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Thu, Dec 20, 2012 at 12:23:58PM -0800, Simon Glass wrote:
> 
> For the key repeat feature, we need to set this after the input device
> is registered. So we would need to add a matrix_keypad_setup_input() or
> similar to be called by the driver after input_register_device(). I am
> less keen on that idea, and less again on the alternative of perhaps
> matrix_keypad_register_device() which does input_register_device() and
> then sets up the key repeat. Thoughts?

No, we already have default rate and delay. Unless you can prove that
random firmware writer's idea of appropriate delay and rate is better
then current default - for everyone - and then can successfully argue
that that obviously best delay/rate combo should not replace the current
one but stay only in DT bindings, let's keep relying on users adjusting
their own preferences from respective desktop environments/console/etc.

Thanks.

-- 
Dmitry
