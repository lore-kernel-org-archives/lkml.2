Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab2EPTf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:35:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52166 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab2EPTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:35:56 -0400
Date: Wed, 16 May 2012 12:35:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] Input: twl6040-vibra: Update for device tree support
Message-ID: <20120516193546.GA15920@core.coreip.homeip.net>
References: <1337167186-8535-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337167186-8535-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, May 16, 2012 at 02:19:46PM +0300, Peter Ujfalusi wrote:
> The twl6040 DT support implementation has been changed from the originally
> planned.
> None of the child devices going to have compatible_of property which means
> that the child devices of twl6040 will be created as traditional MFD devices.
> The mfd core driver will decide (based on the DT blob) to create a device
> for the twl6040-vibra or not. If the DT blob has 'vibra' section the device
> will be created without pdata.
> In this case the vibra driver will reach up to the parent node to get the
> needed properties.

So in this case why don't you have parent parse all DT data and
construct instance of pdata for vibra driver to consume?

Thanks.

-- 
Dmitry
