Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1G0MTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:19:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47367 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750937Ab1G0MTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:19:35 -0400
Date: Thu, 26 May 2011 09:18:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: (wm831x-dcdc) Remove unused variables
Message-ID: <20110526081814.GA28573@opensource.wolfsonmicro.com>
References: <1306393091-6036-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306393091-6036-1-git-send-email-linux@roeck-us.net>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:58:11PM -0700, Guenter Roeck wrote:
> Remove unused variable wm831x from functions wm831x_buckv_remove() and
> wm831x_buckp_remove().

Liam this is the third time someone's sent a fix for this, including one
from me.  Can you please get this applied?
