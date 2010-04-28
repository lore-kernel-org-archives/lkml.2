Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab0D1SxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:53:21 -0400
Received: from kroah.org ([198.145.64.141]:48543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab0D1SxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:53:20 -0400
Date: Wed, 28 Apr 2010 11:40:31 -0700
From: Greg KH <greg@kroah.com>
To: Vikram Dhillon <dhillonv10@gmail.com>
Cc: gregkh@suse.de, andrea.gelmini@gelma.net, linville@tuxdriver.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Staging: arlan: arlan.h: Fixed some style issues
Message-ID: <20100428184031.GC1748@kroah.com>
References: <1268613570-8975-1-git-send-email-dhillonv10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268613570-8975-1-git-send-email-dhillonv10@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 08:39:30PM -0400, Vikram Dhillon wrote:
> Fixed some style issues in accordance with checkpatch.pl. Before the
> patch contained "total: 2 errors, 186 warnings, 535 lines checked" and
> now it has: total: 0 errors, 170 warnings. Most of the warnings that
> remain now are the line over 80 chars ones.

Looks great, now queued up.

greg k-h
