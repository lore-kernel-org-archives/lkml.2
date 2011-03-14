Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1CNWsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:48:23 -0400
Received: from kroah.org ([198.145.64.141]:37467 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462Ab1CNWsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:48:22 -0400
Date: Mon, 14 Mar 2011 15:47:46 -0700
From: Greg KH <greg@kroah.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/trivial: Fix common spelling mistakes
Message-ID: <20110314224746.GA21100@kroah.com>
References: <alpine.LNX.2.00.1103141259500.19969@pobox.suse.cz>
 <1300139875-8688-1-git-send-email-peterhuewe@gmx.de>
 <20110314220313.GA21204@kroah.com>
 <201103142343.23504.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201103142343.23504.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 11:43:23PM +0100, Peter Hüwe wrote:
> Am Montag 14 März 2011, 23:03:13 schrieb Greg KH:
> > On Mon, Mar 14, 2011 at 10:57:55PM +0100, Peter Huewe wrote:
> > > This patch fixes some very common spelling mistakes in drivers/staging
> > 
> > Unfortunatly, I've applied a bunch of patches since the last linux-next
> > tree.
> > 
> > It would be nice if I could have taken a bunch of these changes, and if
> > it was broken up into individual patches (each either doing only one
> > spelling change, or only operating on one driver/file) then I could
> > have.  But as it is, I can't :(
> > 
> > So, another reason it makes sense to break patches up into the logical
> > pieces.  Please do this and resend.
> 
> Absolutely no problem, Greg. 
> I thought since it is only a simple spellcheck in comments one big spellcheck 
> patch would be logical enough.
> 
> I could split up by driver/directory with reasonable effort - would this be 
> okay with you? Or do you want per file?
> Or do you prefer the changes split by each spelling change?

Either is fine, but you need to split it up somehow please.  Whatever is
easier for you.

> I can recreate the patch(es) however you like them - so just tell me your 
> preference.
> 
> Where can I find you current tree so I can patch against this one?

As per the MAINTAINERS file:
	STAGING SUBSYSTEM
	M:      Greg Kroah-Hartman <gregkh@suse.de>
	T:      git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git

Use the staging-next branch please.

thanks,

greg k-h
