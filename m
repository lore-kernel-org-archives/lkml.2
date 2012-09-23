Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2IWBJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 21:09:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2IWBJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 21:09:58 -0400
Date: Sat, 22 Sep 2012 18:09:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120923010953.GA17663@kroah.com>
References: <20120913095623.GB28508@moon>
 <20120913135131.5b251797@pyramind.ukuu.org.uk>
 <20120913125401.GK19956@moon>
 <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
 <20120922180639.GC11610@moon>
 <20120922200731.GD14004@kroah.com>
 <20120922201144.GD11610@moon>
 <20120922215232.GA25778@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120922215232.GA25778@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 01:52:32AM +0400, Cyrill Gorcunov wrote:
> On Sun, Sep 23, 2012 at 12:11:44AM +0400, Cyrill Gorcunov wrote:
> >
> > > Sysfs is one value per file, you have three values here, please make 3
> > > files.
> > > 
> > > And document them in Documentation/ABI/.
> > 
> > Hmm, sure Greg, I'll update. Thanks!
> 
> Something like below I suppose? Look, if there will be no complains
> on tech aspects on the patch (locking and tty refs) -- I'll update
> Documentation. Just want be sure I've made no mistakes here.
> 
> Another question -- would not it be worth to wrap code with
> CONFIG_CHECKPOINT_RESTORE?

Alan's point stands, what's the use of this if it can instantly change
after you read the value?

greg k-h
