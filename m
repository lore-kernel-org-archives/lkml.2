Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab2ITJDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:03:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25543 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2ITJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:03:20 -0400
Date: Thu, 20 Sep 2012 12:02:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: willy@meta-x.org, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: panel: Fixed a macro coding style issue
Message-ID: <20120920090259.GA4587@mwanda>
References: <1348083609-7852-1-git-send-email-mujeeb.adil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348083609-7852-1-git-send-email-mujeeb.adil@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 01:10:09AM +0530, Adil Mujeeb wrote:
> Removed do {} while (0) loop for a single statement macros
> 
> Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>

Also this patch doesn't apply with -p1.

Send the email to yourself.  Save the raw email including headers
and everything.

cd linux-3.6-rc6
cat raw_email.txt | git am
use `git log -p` to review the commit log.

regards,
dan carpenter

