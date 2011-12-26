Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1LZTO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 14:14:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44199 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab1LZTO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 14:14:56 -0500
Date: Mon, 26 Dec 2011 19:14:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>
Subject: Re: [RFC][PATCH 1/2] PM / Sleep: Introduce "late suspend" and "early
 resume" of devices
Message-ID: <20111226191452.GM8722@opensource.wolfsonmicro.com>
References: <201112230029.20174.rjw@sisk.pl>
 <201112230030.17485.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112230030.17485.rjw@sisk.pl>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 12:30:17AM +0100, Rafael J. Wysocki wrote:

> For the above reasons, introduce new device suspend/resume phases,
> "late suspend" and "early resume" (and analogously for hibernation)
> whose callback will be executed with runtime PM disabled and with
> device interrupts enabled and whose callback pointers generally may
> point to runtime suspend/resume routines.

I can't claim to have gone through the code with a fine toothcomb but
from an interface point of view this is really clear and helpful,
should be very useful:

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
