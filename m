Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936566Ab0COPtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:49:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936228Ab0COPtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:49:46 -0400
Date: Mon, 15 Mar 2010 08:48:44 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [007/145] V4L/DVB: cxusb: Select all required frontend and
 tuner modules
Message-ID: <20100315154844.GA31056@suse.de>
References: <20100313002705.836357664@kvm.kroah.org>
 <1268452122.7439.29.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268452122.7439.29.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 03:48:42AM +0000, Ben Hutchings wrote:
> On Fri, 2010-03-12 at 16:25 -0800, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ----------------
> > From: Ben Hutchings <ben@decadent.org.uk>
> > 
> > commit fc4a7f93087a48619005111895dcaa115f807399 upstream.
> > 
> > cxusb uses the atbm8830 and lgs8gxx (not lgs8gl5) frontends and the
> > max2165 tuner, so it needs to select them.
> 
> I thought I already replied to say this is wrong for 2.6.32.
> 
> The correct change would be:

Sorry about that, you are correct, you did notify me of this, I just
forgot to change it.  I've now updated the patch in the queue.

thanks for reminding me again,

greg k-h
