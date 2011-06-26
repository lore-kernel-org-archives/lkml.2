Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1FZU3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:29:19 -0400
Received: from imr3.ericy.com ([198.24.6.13]:43119 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab1FZU12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:27:28 -0400
Date: Sun, 26 Jun 2011 13:26:48 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: sdevrien@cisco.com
CC: khali@linux-fr.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3] Add support for the Philips SA56004 temperature sensor.
Message-ID: <20110626202648.GA9118@ericsson.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 10:40:45AM -0000, sdevrien@cisco.com wrote:
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
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
I don't see a reason for holding this patch up further. Applied to -next.
If you disagree, please speak up now or be silent forever.

Thanks,
Guenter
