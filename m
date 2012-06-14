Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2FNPhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:37:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34488 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2FNPhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:37:35 -0400
Date: Thu, 14 Jun 2012 08:37:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: ning.n.jiang@gmail.com
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: Deprecate suspend/resume in device_driver
Message-ID: <20120614153730.GB17140@kroah.com>
References: <1339656138-28060-1-git-send-email-ning.n.jiang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339656138-28060-1-git-send-email-ning.n.jiang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 02:42:17PM +0800, ning.n.jiang@gmail.com wrote:
> From: Ning Jiang <ning.n.jiang@gmail.com>
> 
> Make suspend/resume callbacks in device_driver deprecated and scheduled
> for removal since they are not used in PM core anymore.
> 
> Legacy drivers who still use them need to move suspend/resume callbacks
> to dev_pm_ops.

How many complier warnings does this patch produce?

Please fix them before submitting this patch.  The way kernel
development is is that you fix the problems up with the api, you don't
just mark them and hope someone else will do it for you.

Sorry, I can't take this.

greg k-h
