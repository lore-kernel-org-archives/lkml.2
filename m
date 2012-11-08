Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2KHH3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:29:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23048 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2KHH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:29:24 -0500
Date: Thu, 8 Nov 2012 10:29:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Staging: winbond: wb35rx_s: Fixed coding style issue
Message-ID: <20121108072915.GD11515@mwanda>
References: <1352314203-8092-1-git-send-email-mujeeb.adil@gmail.com>
 <1352314203-8092-5-git-send-email-mujeeb.adil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352314203-8092-5-git-send-email-mujeeb.adil@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to use more descriptive subjects on the patches.

This one could probably have been broken into smaller patches
[patch 4/x] Staging: winbond: wb35rx_s: fix white space
[patch 5/x] Staging: winbond: wb35rx_s: fix comments
[patch 6/x] Staging: winbond: wb35rx_s: allow header to be included twice

It's small enough that I don't have strong feelings about it, but
in general that's how you should do it.

regards,
dan carpenter

