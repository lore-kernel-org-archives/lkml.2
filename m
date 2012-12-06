Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2LFG2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:28:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42913 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372Ab2LFG2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:28:45 -0500
Date: Thu, 6 Dec 2012 15:28:38 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhilash Kesavan <kesavan.abhilash@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, lrg@ti.com,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@google.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: Regulator suspend state dt question
Message-ID: <20121206062836.GH10867@opensource.wolfsonmicro.com>
References: <CAM4voa=X_rBkSXRHd=oEOnXhgyfSAeD8LmYnsTeQtd-SYKWwPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM4voa=X_rBkSXRHd=oEOnXhgyfSAeD8LmYnsTeQtd-SYKWwPg@mail.gmail.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 11:55:11AM +0530, Abhilash Kesavan wrote:

> As of now there is no support in the regulator core to specify the suspend state
> (mode, enabled/disabled) using dt. I can add new properties specifying
> the intial_state,
> mode, enable/disable but I am not too sure if it is appropriate to add
> such bindings to
> the device tree as they are not actually describing the hardware.

Well, it does depend on the hardware a bit - some hardware is hard wired
to only have one possible suspend state due to power up requirements.
But for a lot of hardware it's flexible...  

> Is calling regulator_suspend_prepare from a machine specific file an option ?

This is not really relevant, it's an orthogonal thing about when we
trigger the state transition in the regulator.

It's not clear what a good solution is here, sorry.
