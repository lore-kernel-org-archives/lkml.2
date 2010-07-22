Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819Ab0GVStG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:49:06 -0400
Received: from kroah.org ([198.145.64.141]:60750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759994Ab0GVSs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:48:29 -0400
Date: Thu, 22 Jul 2010 11:44:35 -0700
From: Greg KH <greg@kroah.com>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: Remove PUINT from ttype.h
Message-ID: <20100722184435.GB32116@kroah.com>
References: <1278973682-25540-1-git-send-email-roel.vannyen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278973682-25540-1-git-send-email-roel.vannyen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:28:02AM +0200, Roel Van Nyen wrote:
> Remove PUINT from ttype.h and change it to unsigned int *
> 
> Signed-of-by Roel Van Nyen <roel.vannyen@gmail.com>
> ---

Please run your patches through the scripts/checkpatch.pl script before
sending them to me.  I can't add new warnings to the drivers, sorry.

thanks,

greg k-h
