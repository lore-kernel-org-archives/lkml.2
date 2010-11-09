Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0KICpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:45:20 -0500
Received: from imr4.ericy.com ([198.24.6.8]:50350 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab0KICpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:45:19 -0500
Date: Mon, 8 Nov 2010 18:44:39 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Sean MacLennan <smaclennan@pikatech.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (ad7414) Return proper error code
 for ad7414_probe()
Message-ID: <20101109024439.GB20251@ericsson.com>
References: <1289266834.14461.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1289266834.14461.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 08:40:34PM -0500, Axel Lin wrote:
> Return proper error if i2c_check_functionality reports
> the adapter does not support the capability we need.
> 
> Also remove unneeded initialization for err variable.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks,
Guenter
