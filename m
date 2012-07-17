Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2GQBLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:11:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57917 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2GQBLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:11:11 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 16 Jul 2012 18:11:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 2/2] hwmon: (applesmc) Ignore some
 temperature registers
Message-ID: <20120717011115.GB22234@roeck-us.net>
References: <1342423091-330-1-git-send-email-rydberg@euromail.se>
 <1342423091-330-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342423091-330-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 09:18:11AM +0200, Henrik Rydberg wrote:
> Not all sensors in the T range are useful temperatures.  This patch
> creates a subset of sensors to be exported to userland, excluding the
> unknown types.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied to -next.

Thanks,
Guenter
