Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1JHP4C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 11:56:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab1JHPzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 11:55:37 -0400
Date: Sat, 8 Oct 2011 08:47:34 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Einon <mark.einon@gmail.com>
Cc: linville@tuxdriver.com, davem@davemloft.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: et131x: Moving the et131x driver out of staging? (a.k.a. filling
 up the TODO list again)
Message-ID: <20111008154734.GA559@suse.de>
References: <CANK3SE398D+DiXLWDystz_jSpD4WJaLqt9gCmVstr+8TginDRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANK3SE398D+DiXLWDystz_jSpD4WJaLqt9gCmVstr+8TginDRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 11:07:00PM +0100, Mark Einon wrote:
> Hello Greg,
> 
> I've managed to clear out the current TODO list for the staging/et131x
> driver, and hopefully its looking in a much better shape because of
> it.

It is, thanks for the work.

> I'd like to propose moving it out of the staging area, or at least
> getting some review comments regarding what work is still needed.

I think you got some comments and have a bit more work to do now, right?

> Is it a good time to propose this bearing in mind the reorganisation
> of drivers/net/ and the fallout from the kernel.org issues?

I don't think either of those have any bearing on this, does it?

thanks,

greg k-h
