Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0LFPcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:32:20 -0500
Received: from waste.org ([173.11.57.241]:41723 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0LFPcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:32:19 -0500
Subject: Re: [PATCH] add additional audit info (read/write length & rng
 name) for RNG devices
From: Matt Mackall <mpm@selenic.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>
In-Reply-To: <20101206152121.GA13235@hmsreliant.think-freely.org>
References: <20101206152121.GA13235@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 09:32:15 -0600
Message-ID: <1291649535.3065.2088.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 10:21 -0500, Neil Horman wrote:
> Add /dev/[u]random auditing
> 
> Patch to enhance auditing of user visible random number generators.  Allows us to
> determine how many bytes of random data were obtained on each read from an RNG
> device
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

The random.c parts looks fine to me.

Acked-by: Matt Mackall <mpm@selenic.com>

> +	context->aux = (void *)ax;

Redundant cast to void *?

-- 
Mathematics is the supreme nostalgia of our time.


