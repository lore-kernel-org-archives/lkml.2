Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1BSFdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 00:33:21 -0500
Received: from kroah.org ([198.145.64.141]:47014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab1BSFdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 00:33:18 -0500
Date: Fri, 18 Feb 2011 21:34:17 -0800
From: Greg KH <greg@kroah.com>
To: Klaas Neirinck <klaas.neirinck@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org,
        Klaas Neirinck <klaas.nerinck@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] Staging: tidspbridge: fixed a brace coding style
 issue
Message-ID: <20110219053417.GB21529@kroah.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <20110218212752.GJ796@kroah.com>
 <4D5F29D9.1080601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5F29D9.1080601@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 03:24:25AM +0100, Klaas Neirinck wrote:
> On 18/02/2011 22:27, Greg KH wrote:
> >On Thu, Feb 17, 2011 at 03:58:45AM +0100, Klaas Neirinck wrote:
> >>Fixed a coding style issue.
> >>
> >>Signed-off-by: Klaas Neirinck<klaas.nerinck@gmail.com>
> >This doesn't apply at all to the linux-next tree, what did you do it
> >against?
> >
> >confused,
> >
> >greg k-h
> I did it against
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> as shown in http://www.youtube.com/fosdemtalks#p/u/0/LLBrBBImJt4
> great talk btw!

Thanks, but the patches really need to be against linux-next, which I
didn't really spell out very well in that talk, sorry.  linux-next
contains all of the patches that others have sent me that are queued up
for the next kernel release after this one.

Hope this helps,

greg k-h
