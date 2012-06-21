Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab2FUNoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 09:44:10 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:33189 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759673Ab2FUNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 09:44:08 -0400
X-Greylist: delayed 752 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2012 09:44:08 EDT
Date: Thu, 21 Jun 2012 09:31:11 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: Bad rss-counter state
Message-ID: <20120621133111.GA13820@elliptictech.com>
References: <20120620194908.GA16353@elliptictech.com>
 <20120621095024.GA10745@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621095024.GA10745@tiehlicka.suse.cz>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-21 11:50 +0200, Michal Hocko wrote:
> On Wed 20-06-12 15:49:08, Nick Bowler wrote:
> > Hi folks,
> > 
> > I just noticed the following couple lines in my kernel log for Linux
> > 3.4.2:
> > 
> >   Jun 20 14:57:54 emergent kernel: BUG: Bad rss-counter state mm:ffff88000ff1f400 idx:1 val:-2
> >   Jun 20 14:57:54 emergent kernel: BUG: Bad rss-counter state mm:ffff88000ff1f400 idx:2 val:2
> > 
> > I have no idea what these messages mean, nor what I was doing exactly
> > at 14:57:54 today, nor whether they've been fixed in newer kernels.
> > Regardless, they appear to be telling me that there's a kernel problem
> > since they contain the word "BUG", so I figured I had better report them
> > nonetheless.  Other than the fact that these messages were printed, the
> > system is operating normally.
> 
> The issue is known and the fix can be found at
> https://lkml.org/lkml/2012/6/9/47

Ah, and it appears to have been merged by Linus yesterday.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

