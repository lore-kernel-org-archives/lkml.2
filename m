Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1KDVHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:07:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab1KDVHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:07:13 -0400
Date: Fri, 4 Nov 2011 14:04:47 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Xiaotian Feng <dfeng@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [050/107] block: check for proper length of iov entries earlier
 in blk_rq_map_user_iov()
Message-ID: <20111104210447.GA3934@suse.de>
References: <20111102221600.GA26650@kroah.com>
 <20111102221454.703920975@clark.kroah.org>
 <1320420256.3079.172.camel@deadeye>
 <20111104171425.GA4893@suse.de>
 <20111104190616.GB3366@decadent.org.uk>
 <20111104202806.GA9715@suse.de>
 <20111104210055.GK4751@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104210055.GK4751@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 12:00:55AM +0300, Dan Carpenter wrote:
> On Fri, Nov 04, 2011 at 01:28:06PM -0700, Greg KH wrote:
> > Doesn't this still fix one issue here, just not both of them described,
> > right?
> 
> Not really.
> 
> We've got a list from 0 - 100.  We should be checking them all.
> If number 50 is unaligned in the old version we would check 0 - 50,
> but with this patch applied we check from 0 to 51.

Ugh, you are right.

Xiaotian, please fix this correctly upstream, I'll go drop this patch
for now from the stable trees.

thanks,

greg k-h
