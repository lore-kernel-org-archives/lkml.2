Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029Ab0HEJEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:04:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45786 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886Ab0HEJE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:04:29 -0400
Date: Thu, 5 Aug 2010 11:04:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <gregkh@suse.de>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        tytso@mit.edu
Subject: Re: new gerneric kfifo API
Message-ID: <20100805090424.GD29966@basil.fritz.box>
References: <201005132135.o4DLZ9WI021613@imap1.linux-foundation.org>
 <1280905854.8441.3.camel@wall-e.seibold.net>
 <20100804194617.GA30773@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804194617.GA30773@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:46:17PM -0700, Greg KH wrote:
> On Wed, Aug 04, 2010 at 09:10:54AM +0200, Stefani Seibold wrote:
> > Hi,
> > 
> > once again. Kernel 2.6.35 is out and i want to know if there is play plan to
> > merge the generic kfifo API. All complains was fixed, so there is no
> > reason to shift the merge again. Please gibe me a short answer.
> 
> These have been in the -mm tree for a few major kernel releases now,
> right?  And they are API safe, and only change the internals, right?

I thought they changed the API. But generally to the better.

The newer version seemed ok to me last time I looked.
The older version it replaced had some issues.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
