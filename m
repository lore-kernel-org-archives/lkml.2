Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab1HJIHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:07:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1HJIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:06:59 -0400
Date: Wed, 10 Aug 2011 11:04:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH] Staging: comedi: fix printk() issue in das6402.c
Message-ID: <20110810080449.GC3706@shale.localdomain>
References: <1312954420-3470-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312954420-3470-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_printk() can't be used with KERN_CONT.  It always prints:

        return printk("%s%s %s: %pV",
	                      level, dev_driver_string(dev), dev_name(dev), vaf);

That's perhaps a problem in dev_printk() which should be changed.  I
don't feel strongly either way...

regards,
dan carpenter

