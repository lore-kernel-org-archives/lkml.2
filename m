Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1AXOzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:55:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1AXOzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:55:08 -0500
Date: Mon, 24 Jan 2011 09:54:51 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andy Walls <awalls@md.metrocast.net>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/staging/lirc: Remove obsolete cleanup for
 clientdata
Message-ID: <20110124145451.GD28403@redhat.com>
References: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
 <1295865880-27672-4-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295865880-27672-4-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:44:30AM +0100, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit or error. This is obsolete meanwhile, the core will do it. Simplify the
> kfree() calls after that, the pointers don't need to be checked.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Jarod Wilson <jarod@redhat.com>
> Cc: Joe Perches <joe@perches.com>
> ---
> 
> Compile tested only.

Looks sane to me.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

