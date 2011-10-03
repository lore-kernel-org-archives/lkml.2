Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1JCOek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:34:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47634 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab1JCOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:34:35 -0400
X-Sasl-enc: +8kvepGuraiT2gXdsqrWRAVDMXnfHDF/3Wd7U8IUw1n3 1317652474
Date: Mon, 3 Oct 2011 07:13:12 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111003141312.GA4901@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20111001140519.GA26662@kroah.com>
 <20111003091430.GA13919@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003091430.GA13919@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:14:30AM -0400, Steven Rostedt wrote:
> On Sat, Oct 01, 2011 at 07:05:19AM -0700, Greg KH wrote:
> > 
> > I would recommend a physical access device for your new gpg key that you
> > create.  I've heard good things about this USB device:
> > 	http://www.crypto-stick.org/
> > and am trying to have a bunch of them at the Kernel Summit this year to
> > hand out to people if they want one.
> 
> Hmm, if I'm going to get one at KS, should I stop getting signed keys
> now? A few of us have already started the GPG song and dance to get
> signed keys over the phone (where we know each other enough to know
> phone numbers and recognize voices).

You can put a key into the device, and then delete it from your
computer, so you don't have to create the key in the device.

Hope this helps,

greg k-h
