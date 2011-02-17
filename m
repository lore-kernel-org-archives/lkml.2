Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab1BQT5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:57:07 -0500
Received: from kroah.org ([198.145.64.141]:42937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab1BQT5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:57:06 -0500
Date: Thu, 17 Feb 2011 11:54:00 -0800
From: Greg KH <greg@kroah.com>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 09/12] n_tracesink header file.
Message-ID: <20110217195400.GB12172@kroah.com>
References: <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-9-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
 <20110217192300.GD29448@kroah.com>
 <1297971915.3038.32.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297971915.3038.32.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 11:45:15AM -0800, J Freyensee wrote:
> On Thu, 2011-02-17 at 11:23 -0800, Greg KH wrote:
> > On Tue, Feb 08, 2011 at 11:34:54AM -0800, james_p_freyensee@linux.intel.com wrote:
> > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > 
> > > This header file allows the n_tracerouter to send it's information
> > > to the n_tracesink ldisc driver.  It's part of the Intel-Atom
> > > PTI implementation solution.
> > > 
> > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > ---
> > >  include/linux/n_tracesink.h |   32 ++++++++++++++++++++++++++++++++
> > 
> > Why is this in include/linux/ ?
> > 
> 
> I thought this was the best place to stick this .h file.  I'd be happy
> to change locations based off of your suggestion.

Why do you need a .h file at all?  Who is using it?

thanks,

greg k-h
