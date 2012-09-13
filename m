Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2IMNp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:45:59 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56587 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2IMNp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:45:57 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 13 Sep 2012 06:46:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Luca Tettamanti <kronos.it@gmail.com>, kernel-janitors@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] drivers/hwmon/asus_atk0110.c: Remove useless kfree
Message-ID: <20120913134603.GB1400@roeck-us.net>
References: <1347462407-13499-4-git-send-email-peter.senna@gmail.com>
 <20120912161925.GA22539@roeck-us.net>
 <20120913090506.5f2d6834@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913090506.5f2d6834@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:05:06AM +0200, Jean Delvare wrote:
> On Wed, 12 Sep 2012 09:19:25 -0700, Guenter Roeck wrote:
> > On Wed, Sep 12, 2012 at 05:06:42PM +0200, Peter Senna Tschudin wrote:
> > > From: Peter Senna Tschudin <peter.senna@gmail.com>
> > > 
> > > Remove useless kfree() and clean up code related to the removal.
> > 
> > Queued for -next.
> 
> Patch looks good, but I don't see any "code clean-up". Either it was
> intended but forgotten, or the patch description claims too much.
> 
Thought that referred to the kfree. You are right, that isn't really a cleanup.
I'll drop that comment.

Guenter
