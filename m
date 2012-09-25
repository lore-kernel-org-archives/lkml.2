Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2IYNaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:30:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24070 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2IYNax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:30:53 -0400
Date: Tue, 25 Sep 2012 16:30:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        ldv-project@linuxtesting.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/gdm72xx: coding style fixes gdm_qos.c
Message-ID: <20120925133033.GT4587@mwanda>
References: <1348577632-25462-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348577632-25462-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 04:53:52PM +0400, Alexey Khoroshilov wrote:
> Fix checkpatch.pl warnings:
> WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
> WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
> WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
> 

Better to just replace the dprintk macros instead of prettifying
them.

regards,
dan carpenter

