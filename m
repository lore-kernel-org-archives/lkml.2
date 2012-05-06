Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab2EFGkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 02:40:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26276 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2EFGkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 02:40:41 -0400
Date: Sun, 6 May 2012 09:42:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com,
        andor.daam@googlemail.com, grabner@icg.tugraz.at, jj@chaosbits.net,
        thomas@m3y3r.de
Subject: Re: [PATCH 5/8] drivers/staging/line6/driver.h: Changed
 printk(KERN_ERR, .. to pr_err Changed printk(KERN_ERR, ...) call to pr_err()
 call in MISSING_CASE macro
Message-ID: <20120506064218.GK22134@mwanda>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
 <1336228312-5379-6-git-send-email-morbidrsa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336228312-5379-6-git-send-email-morbidrsa@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MISSING_CASE is a horrible macro.  Just replace all the code which
uses MISSING_CASE.  Or better yet, delete all the uses.  (I haven't
looked through them).

regards,
dan carpenter

