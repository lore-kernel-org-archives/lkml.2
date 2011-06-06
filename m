Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1FFMlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:41:47 -0400
Received: from imr4.ericy.com ([198.24.6.8]:49201 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab1FFMlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:41:46 -0400
Date: Mon, 6 Jun 2011 05:40:47 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "sdevrien@cisco.com" <sdevrien@cisco.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Add support for the Philips SA56004 temperature
 sensor.
Message-ID: <20110606124047.GA26180@ericsson.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 06:40:45AM -0400, sdevrien@cisco.com wrote:
> From: Stijn Devriendt <sdevrien@cisco.com>
> 
> Add support for the Philips SA56004, an LM86
> compatible temperature sensor.
> 
> Changes since v2:
> - Changed BUG_ON to WARN_ON
> Changes since v1:
> - Updated documentation
> - Trace replaced by BUG_ON
> - style updates
> 
> Signed-off-by: Stijn Devriendt <sdevrien@cisco.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

Jean, do you want to take this and/or have a look, or should I ?

Thanks,
Guenter
