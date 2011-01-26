Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1AZCxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 21:53:18 -0500
Received: from kroah.org ([198.145.64.141]:52907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1AZCw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 21:52:59 -0500
Date: Wed, 26 Jan 2011 10:48:31 +0800
From: Greg KH <greg@kroah.com>
To: Aaron Durbin <adurbin@google.com>
Cc: Jeff Garzik <jeff@garzik.org>, Mike Waychison <mikew@google.com>,
        torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 1/6] Add oops notification chain.
Message-ID: <20110126024831.GD28283@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002439.12637.8515.stgit@mike.mtv.corp.google.com>
 <20110125020658.GA3481@kroah.com>
 <AANLkTinLoDN_6zG56J7V154jrRc-K+BzAHFO3qS_r8J0@mail.gmail.com>
 <4D3F4275.50709@garzik.org>
 <AANLkTim4fG0-F0+E-DHa4=XGdk1rFbRA68nvt9bfURiK@mail.gmail.com>
 <4D3F4699.60809@garzik.org>
 <AANLkTinUmB003g3Cb0yUXf7LeTvc=BMWN6MGcGJW0QrJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinUmB003g3Cb0yUXf7LeTvc=BMWN6MGcGJW0QrJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 02:21:03PM -0800, Aaron Durbin wrote:
> As Mike talked about it might be more desirable to actually pass a
> reason field that indicates the appropriate kernel event. However, the
> naming of some of the variables becomes less clear. Maybe name it
> panic_oops_notifier_list? That way there would only be a single
> notifier chain.

Yes, I think that's the better thing to do here instead of adding more
notifier chains.  It would just start to get even messier than it
currently is :)

thanks,

greg k-h
