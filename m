Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2IMHGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:06:00 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48987 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2IMHF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:05:58 -0400
Date: Thu, 13 Sep 2012 09:05:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Luca Tettamanti <kronos.it@gmail.com>, kernel-janitors@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] drivers/hwmon/asus_atk0110.c: Remove useless kfree
Message-ID: <20120913090506.5f2d6834@endymion.delvare>
In-Reply-To: <20120912161925.GA22539@roeck-us.net>
References: <1347462407-13499-4-git-send-email-peter.senna@gmail.com>
	<20120912161925.GA22539@roeck-us.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012 09:19:25 -0700, Guenter Roeck wrote:
> On Wed, Sep 12, 2012 at 05:06:42PM +0200, Peter Senna Tschudin wrote:
> > From: Peter Senna Tschudin <peter.senna@gmail.com>
> > 
> > Remove useless kfree() and clean up code related to the removal.
> 
> Queued for -next.

Patch looks good, but I don't see any "code clean-up". Either it was
intended but forgotten, or the patch description claims too much.

-- 
Jean Delvare
