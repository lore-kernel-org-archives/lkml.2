Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2BXIWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:22:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58927 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2BXIWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 03:22:03 -0500
Date: Fri, 24 Feb 2012 00:21:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Fox <pgf@laptop.org>,
        Martin Langhoff <martin@laptop.org>
Subject: Re: [PATCH] input: psmouse:  create an 'enabled' sysfs attribute to
 squelch mouse
Message-ID: <20120224082158.GA18291@core.coreip.homeip.net>
References: <20120217180634.6162196e@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217180634.6162196e@debxo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Fri, Feb 17, 2012 at 06:06:34PM -0800, Andres Salomon wrote:
> 
> From: Paul Fox <pgf@laptop.org>
> 
> on OLPC XO laptops, at least one model of touchpad (sentelic)
> emits continuous jittery motion reports when the laptop is
> configured in "ebook" mode.  the touchpad is inaccessible in
> that configuration, so we simply disable it.
> 
> these motion reports will wake the SoC when put to sleep, so simply
> ignoring the events is not a possibilty; the device must be disabled.

Can you switch the AUX serio port into manual bind mode (viqa sysfs) and
simply connect/disconnect the touchpad as needed (again via sysfs)?

Thanks.

-- 
Dmitry
