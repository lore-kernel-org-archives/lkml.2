Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2BLV21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:28:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48744 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab2BLV2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:28:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
Date: Sun, 12 Feb 2012 22:32:12 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        Greg KH <greg@linuxfoundation.org>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl> <201202100144.11123.rjw@sisk.pl> <20120212020507.GD18742@gs62>
In-Reply-To: <20120212020507.GD18742@gs62>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202122232.12541.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 12, 2012, mark gross wrote:
> On Fri, Feb 10, 2012 at 01:44:10AM +0100, Rafael J. Wysocki wrote:
[...]
> > I'd like us and Android to use the same low-level data structures for power
> > management and the same API eventually, at least for drivers.  This is not
> > the case at the moment and it's actively hurting us as a project quite a bit.
> > If Android needs to add patches on top of whatever we have to get the desired
> > functionality, I'm fine with that, as long as they don't require drivers to use
> > APIs that are incompatible with the mainline.  Insisting that Android should
> > use a user-space-based autosleep implementation wouldn't help at all, because
> > realistically this isn't going to happen.
> 
> why not?  I don't think having the PMS explicitly acknowledge a wake
> event is a big ask at all.

I'd like to hear what the Android people think about that, but somehow it seems
to me they won't like it. :-)

Thanks,
Rafael
