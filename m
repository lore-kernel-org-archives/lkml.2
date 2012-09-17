Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2IQMSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 08:18:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36862 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab2IQMSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:18:36 -0400
Date: Mon, 17 Sep 2012 05:18:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: wharms@bfs.de, kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/9] drivers/staging/gdm72xx/gdm_sdio.c: Remove
 useless kfree
Message-ID: <20120917121831.GA23117@kroah.com>
References: <1347610518-3099-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347610518-3099-1-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:15:18AM +0200, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Remove useless kfree() and clean up code related to the removal.

As I already applid your first patch, care to just send an incremental
patch that makes the change you did here?

thanks,

greg k-h
