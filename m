Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2FLTZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:25:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41465 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2FLTZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:25:00 -0400
Date: Tue, 12 Jun 2012 22:23:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Chan <benchan@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Sage Ahn <syahn@gctsemi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: Fix spinlock recursion on
 gdm_usb_send_complete
Message-ID: <20120612192359.GY4400@mwanda>
References: <1339048886-11956-1-git-send-email-benchan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339048886-11956-1-git-send-email-benchan@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:01:26PM -0700, Ben Chan wrote:
> This patch fixes a spinlock recursion bug on several call sites of
> gdm_usb_send_complete by not calling spin_lock_irqsave on
> urb->context->tx_cxt->lock when the lock has already been acquired.
> 
> Signed-off-by: Ben Chan <benchan@chromium.org>
> Cc: Sage Ahn <syahn@gctsemi.com>
> ---

Ben doesn't want this patch appied.  He sent a version 2 in a later
thread.

regards,
dan carpenter
