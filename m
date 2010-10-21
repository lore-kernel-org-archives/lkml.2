Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0JUNkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:40:08 -0400
Received: from kroah.org ([198.145.64.141]:39344 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab0JUNkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:40:07 -0400
Date: Thu, 21 Oct 2010 06:35:07 -0700
From: Greg KH <greg@kroah.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-bluetooth@vger.kernel.org, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Bluetooth: fix crash in L2CAP
Message-ID: <20101021133507.GB20184@kroah.com>
References: <1287638393-8573-1-git-send-email-padovan@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287638393-8573-1-git-send-email-padovan@profusion.mobi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 03:19:52AM -0200, Gustavo F. Padovan wrote:
> Hi Greg,
> 
> The following patch is good for 2.6.36.1. It arrived too late in linux-bluetooth
> and we didn't had time to put it into 2.6.36. It fixes a serious crash into
> the L2CAP layer. The issue isn't in 2.6.35 and below.

It needs to get into Linus's tree before I can accept it into the
-stable trees.  Please get it there and then send stable@kernel.org the
git commit id and I will add it.

Instructions on how to do this are in the file,
Documentation/stable_kernel_rules.txt.  Please read that for how to
properly do this.

thanks,

greg k-h
