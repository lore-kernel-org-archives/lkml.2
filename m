Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347Ab2ILQT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:19:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49725 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2ILQTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:19:24 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 12 Sep 2012 09:19:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, kernel-janitors@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] drivers/hwmon/asus_atk0110.c: Remove useless kfree
Message-ID: <20120912161925.GA22539@roeck-us.net>
References: <1347462407-13499-4-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347462407-13499-4-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 05:06:42PM +0200, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Remove useless kfree() and clean up code related to the removal.
> 

Queued for -next.

Thanks,
Guenter
