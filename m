Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2KISpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:45:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36508 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2KISpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:45:00 -0500
Date: Fri, 9 Nov 2012 16:44:54 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [ANNOUNCE] Extended stable support for Linux 3.5
 (linux-3.5.y-ext.z)
Message-ID: <20121109184453.GA3011@herton-Z68MA-D2H-B3>
References: <1352470505-6097-1-git-send-email-herton.krzesinski@canonical.com>
 <20121109152203.GA3861@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109152203.GA3861@elie.Belkin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 07:22:03AM -0800, Jonathan Nieder wrote:
> Hi Herton,
> 
> Herton Ronaldo Krzesinski wrote:
> 
> > I plan to do a similar workflow as to what is done today with current
> > stable releases. I'll send email notifications to everyone involved in
> > each patch when it's added to 3.5 queue, and post the patches for review
> > for each release cycle. Just versioning will be slightly different,
> > every version is planned to be tagged as v3.5.7-ext.<release number>,
> > ext meaning extended, 3.5.7 was the last stable kernel in 3.5 kernel and
> > should remain constant.
> 
> Thanks for your work.  Is there a reason not to work with Greg to
> release these on kernel.org with increasing 3.5.8, 3.5.9, etc version
> numbers?

We tried that before with 3.2 but were denied, and decided this time to
go with 3.5 in this way. Luckily Ben Hutchings stepped up and took 3.2,
and is doing an awesome job btw. But if something changed I'm open for
maintaining 3.5 along with other stable trees currently being maintained.

> 
> Curious,
> Jonathan
> 

-- 
[]'s
Herton
