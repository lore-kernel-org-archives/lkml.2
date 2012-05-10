Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab2EJPK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:10:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40085 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757948Ab2EJPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:10:53 -0400
X-Sasl-enc: W/H+oY6/okC9c6FCz5VaV+La+gb8/txX5RlSN0JloLYt 1336662652
Date: Thu, 10 May 2012 08:10:51 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 driver-core tree
Message-ID: <20120510151051.GC17472@kroah.com>
References: <20120510173401.263f10f33f918bfc9e0bec88@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510173401.263f10f33f918bfc9e0bec88@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 05:34:01PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/misc/Makefile between commit 6a7e2618b3db ("misc: MAX8997: Remove
> max8997-muic driver") from the driver-core tree and commit ffc2825c2942
> ("Staging: mei: move the mei code out of staging") from the staging tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good to me, thanks for this.

greg k-h
