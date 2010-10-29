Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab0J2BnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 21:43:16 -0400
Received: from kroah.org ([198.145.64.141]:33681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324Ab0J2BnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 21:43:07 -0400
Date: Thu, 28 Oct 2010 18:38:43 -0700
From: Greg KH <greg@kroah.com>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Pavel Machek <pavel@ucw.cz>, Vasiliy Kulikov <segooon@gmail.com>,
        Iliyan Malchev <ibm@android.com>, Brian Swetland <swetland@google.com>,
        San Mehat <san@android.com>, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/8] staging: dream: fix information leak to userland
Message-ID: <20101029013843.GA9922@kroah.com>
References: <1288296098-18936-1-git-send-email-segooon@gmail.com> <20101028204509.GC22785@kroah.com> <20101028205831.GD19421@elf.ucw.cz> <20101028210802.GA23773@kroah.com> <4CCA2445.7070705@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCA2445.7070705@codeaurora.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 06:32:53PM -0700, Bryan Huntsman wrote:
> >>> Pavel, it looks like you're not doing any dream work anymore, any
> >>> problems with me dropping it?
> >>
> >> Too busy to do any real work on Dream, sorry :-(.
> > 
> > Ok, I think I'll just drop it unless someone screams.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Greg, I'll check around internally and see if there are any concerns
> about dropping it.  I'll get back to you soon.  Thanks.

Wonderful, thanks for doing this.

greg k-h
