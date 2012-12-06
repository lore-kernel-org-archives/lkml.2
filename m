Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab2LFGZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:25:14 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46800 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2LFGZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:25:12 -0500
MIME-Version: 1.0
Date: Thu, 6 Dec 2012 11:55:11 +0530
Message-ID: <CAM4voa=X_rBkSXRHd=oEOnXhgyfSAeD8LmYnsTeQtd-SYKWwPg@mail.gmail.com>
Subject: Regulator suspend state dt question
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olofj@google.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Max77686 PMIC has dt support and I wanted to specify the suspend state of the
regulator via dt. set_suspend_disable and set_suspend_mode call-backs are
already implemented in drivers/regulator/max77686.c.

As of now there is no support in the regulator core to specify the suspend state
(mode, enabled/disabled) using dt. I can add new properties specifying
the intial_state,
mode, enable/disable but I am not too sure if it is appropriate to add
such bindings to
the device tree as they are not actually describing the hardware.

Is calling regulator_suspend_prepare from a machine specific file an option ?

Kindly provide me with suggestions as to how I may proceed with this.

Regards,
Abhilash
