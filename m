Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab1JTAUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 20:20:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1JTAUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 20:20:32 -0400
Date: Wed, 19 Oct 2011 17:20:28 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, kernel-janitors@vger.kernel.org
Subject: Re: [patch] memory hotplug: release lock on an error path
Message-ID: <20111020002027.GB21703@tiehlicka.suse.cz>
References: <20111005055326.GA32187@elgon.mountain>
 <20111018212931.GB10656@tiehlicka.suse.cz>
 <20111018222805.GB24215@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018222805.GB24215@longonot.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-10-11 01:28:05, Dan Carpenter wrote:
> On Tue, Oct 18, 2011 at 02:29:32PM -0700, Michal Hocko wrote:
> > On Wed 05-10-11 08:53:26, Dan Carpenter wrote:
> > > We need to release the mutex here before returning.
> > 
> > Which kernel have you used as a base? I do not see any code like that in
> > the vanilla kernel. And git log doesn't know anything about
> > check_page_reservations in the file as well...
> > 
> 
> Sorry this was against linux-next.

Would be good to mention which patch introduces this in the patch
description.

> 
> regards,
> dan carpenter
> 

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
