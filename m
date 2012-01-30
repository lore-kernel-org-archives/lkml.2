Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2A3W11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:27:27 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48203 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554Ab2A3W1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:27:25 -0500
X-Sasl-enc: BCNthPgi9fc7ZNM5bDkdK2JctcYTdUUd8VGrpaICBumc 1327962443
Date: Mon, 30 Jan 2012 14:27:17 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: sysfs regression: wrong link counts
Message-ID: <20120130222717.GA6393@kroah.com>
References: <4F27120A.4040106@suse.cz>
 <20120130220611.GA26655@kroah.com>
 <20120130221059.26ab5edf@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130221059.26ab5edf@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 10:10:59PM +0000, Alan Cox wrote:
> > Isn't there some other "proper" way of doing this in userspace, or is
> > this really the correct way?
> 
> You can look at the S_IFMT bits and stuff however link count indicating
> number of subdirectories is a standard Unix thing and used by many quite
> mundane tools as an optimisation.

Ah, yeah, that is easier.

Eric, care to fix this or want me to revert it?

thanks,

greg k-h
