Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0JJNIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 09:08:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57334 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0JJNIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 09:08:47 -0400
Date: Sun, 10 Oct 2010 15:08:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010130842.GE8256@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB1B3B9.4030205@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 02:38:17PM +0200, Milan Broz wrote:
> 
> On 10/10/2010 01:59 PM, Andi Kleen wrote:
> > DM-CRYPT: Scale to multiple CPUs v3
> > 
> > [Due to popular demand this is a port of the dm-crypt scalability
> > patch to 2.6.36-rc7.  The 2.6.35 and .32 patches were widely used by
> > lots of users with good results. 
> > 
> 
> Hi Andi,
> 
> please can you check split patches in
> http://mbroz.fedorapeople.org/dm-crypt/2.6.36-devel/
> 
> is there some change in your new version?

Yes I updated the work queue setup and ported it to
all these changes in 2.6.36.

See the changelog in the description.

I did it intentionally not split up because a split up is unlikely
to be bisectable. I think there is no need for any splitups.

> Can I send this to dm-devel instead? 
> (It is better for review.)

What review? The code has been ready since last merge window at least
and was revied back then is my understanding.

The various versions I posted have been extensively tested
by lots of people, including me.

-Andi

