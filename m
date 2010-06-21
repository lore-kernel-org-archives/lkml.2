Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab0FUNnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:43:12 -0400
Received: from THUNK.ORG ([69.25.196.29]:38722 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab0FUNnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:43:09 -0400
Date: Mon, 21 Jun 2010 09:42:49 -0400
From: tytso@mit.edu
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100621134249.GG6199@thunk.org>
Mail-Followup-To: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <201006202350.27143.rjw@sisk.pl>
 <Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
 <20100621061345.GF9735@gvim.org>
 <20100621121058.GF6199@thunk.org>
 <20100621132234.5eb880b0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621132234.5eb880b0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 01:22:34PM +0100, Alan Cox wrote:
> 
> You seem desperate to just throw it at Linus - you have been all along
> before the discussion, during it and now: but I don't understand why ?

Why are you so afraid to let Linus make the call?  He's the benevolent
dictator, isn't he?

> It's as if you don't want progress to be made by other means ?

It doesn't look like progress is being made here.

   	   	     	      	       	    - Ted
