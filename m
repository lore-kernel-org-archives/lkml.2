Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1GDUDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 16:03:06 -0400
Received: from csmtp2.one.com ([91.198.169.22]:59420 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab1GDUDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 16:03:04 -0400
Date: Mon, 4 Jul 2011 22:06:18 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chris Hudson <chudson@kionix.com>, eric.miao@linaro.org
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
Message-ID: <20110704200618.GA7917@skinner.xfiles.lan>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
 <4E0D8E94.5030604@cam.ac.uk>
 <4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>
 <4E105284.7030209@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E105284.7030209@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > # sensors - pressure
> > pressure/bma085.c
> As Manuel Stahl confirmed he also has a driver for this.

FYI - We are working on a new version of the bmp085 driver with support for
some new pressure sensors from Bosch Sensortec. The plan is to
contribute that code in a near future.

-- 
Best regards,
 Eric

http://www.unixphere.com
