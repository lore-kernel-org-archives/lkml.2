Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab1E0IBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:01:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65317 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab1E0IBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:01:06 -0400
Date: Fri, 27 May 2011 02:01:00 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: simon@mungewell.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        OliverNeukumoliver@neukum.org
Subject: Re: [PATCH] input: Add Nintendo extension controller driver
Message-ID: <20110527080100.GB907@ponder.secretlab.ca>
References: <20110516214608.17011.3075.stgit@ponder>
 <87fwo5ywdh.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwo5ywdh.fsf@macbook.be.48ers.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 10:50:34PM +0200, Peter Korsgaard wrote:
> >>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:
> 
>  Grant> This driver adds support for Nintendo Wiimote extension controllers
>  Grant> directly attached to an i2c bus, such as when using an adaptor like
>  Grant> the Wiichuck.
> 
> 
>  Grant> + * If the device is recognized, then the polling period is bumped up
>  Grant> + * to 50ms, and the state machine enters into a loop alternating
> 
> <snip>
> 
>  Grant> +#else
>  Grant> +#define WIICHUCK_CAPTURE_PERIOD (100)	/* 100 milliseconds */
> 
> 50 or 100ms?

Good catch.  It's 100ms.  Now fixed, thanks.

g.

