Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629Ab0J2TkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:40:19 -0400
Received: from kroah.org ([198.145.64.141]:45527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab0J2TkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:40:17 -0400
Date: Fri, 29 Oct 2010 12:40:07 -0700
From: Greg KH <greg@kroah.com>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Pavel Machek <pavel@ucw.cz>, Vasiliy Kulikov <segooon@gmail.com>,
        Iliyan Malchev <ibm@android.com>, Brian Swetland <swetland@google.com>,
        San Mehat <san@android.com>, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/8] staging: dream: fix information leak to userland
Message-ID: <20101029194007.GA12349@kroah.com>
References: <1288296098-18936-1-git-send-email-segooon@gmail.com>
 <20101028204509.GC22785@kroah.com>
 <20101028205831.GD19421@elf.ucw.cz>
 <20101028210802.GA23773@kroah.com>
 <4CCA2445.7070705@codeaurora.org>
 <20101029013843.GA9922@kroah.com>
 <4CCB11F4.9080908@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCB11F4.9080908@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 11:27:00AM -0700, Bryan Huntsman wrote:
> 
> >> Greg, I'll check around internally and see if there are any concerns
> >> about dropping it.  I'll get back to you soon.  Thanks.
> > 
> > Wonderful, thanks for doing this.
> > 
> > greg k-h
> 
> No concerns from us.  Feel free to drop it.  Thanks.

Great, will do, thanks for letting me know.

greg k-h
