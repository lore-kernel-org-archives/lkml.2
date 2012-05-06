Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab2EFGiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 02:38:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25995 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2EFGiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 02:38:21 -0400
Date: Sun, 6 May 2012 09:40:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com,
        andor.daam@googlemail.com, grabner@icg.tugraz.at, jj@chaosbits.net,
        thomas@m3y3r.de
Subject: Re: [PATCH 4/8] drivers/staging/line6/config.h: changed
 printk(KERN_INFO, ... to pr_info(
Message-ID: <20120506064004.GJ22134@mwanda>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
 <1336228312-5379-5-git-send-email-morbidrsa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336228312-5379-5-git-send-email-morbidrsa@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 04:31:48PM +0200, Johannes Thumshirn wrote:
> Changed printk(KERN_INFO, ...) call to pr_info call in CHECKPOINT macro
> 

CHECKPOINT is never used.  Just delete it.

regards,
dan carpenter

