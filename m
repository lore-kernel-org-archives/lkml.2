Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab0LHELJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:11:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:48468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab0LHELG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:11:06 -0500
Date: Tue, 7 Dec 2010 19:58:24 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
        avi@redhat.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [046/127] KVM: VMX: Fix host userspace gsbase
 corruption
Message-ID: <20101208035824.GA31612@suse.de>
References: <20101208004428.893591835@clark.site>
 <1291774337.25629.96.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291774337.25629.96.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 02:12:17AM +0000, Ben Hutchings wrote:
> On Tue, 2010-12-07 at 16:43 -0800, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Ben Hutchings <ben@decadent.org.uk>
> 
> This should be credited primarily to Avi.

He credited you, so just go with it :)

thanks,

greg k-h
