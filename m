Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab0KPUPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:15:44 -0500
Received: from kroah.org ([198.145.64.141]:57067 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759448Ab0KPUPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:15:34 -0500
Date: Tue, 16 Nov 2010 12:13:07 -0800
From: Greg KH <greg@kroah.com>
To: Al Cho <acho@novell.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, jlee@novell.com, segooon@gmail.com
Subject: Re: [PATCH 1/3] staging/keucr: fix keucr init code style
Message-ID: <20101116201307.GA15941@kroah.com>
References: <1289887856-2884-1-git-send-email-acho@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289887856-2884-1-git-send-email-acho@novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:10:56PM +0800, Al Cho wrote:
> fix keucr init.c init.h code style

What tree did you make this patch against?  It doesn't apply to the
linux-next tree (nor does your 3 others), so can you refresh it against
the latest linux-next tree and resend all of them?

thanks,

greg k-h
