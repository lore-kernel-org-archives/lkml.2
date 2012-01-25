Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2AYVo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:44:28 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29375 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2AYVo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:44:26 -0500
Date: Wed, 25 Jan 2012 22:44:32 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@suse.de>
cc: Igor Grinberg <grinberg@compulab.co.il>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [000/129] 3.2.2-stable review
In-Reply-To: <20120124165204.GB26552@suse.de>
Message-ID: <alpine.LNX.2.00.1201252244150.4417@swampdragon.chaosbits.net>
References: <20120124024041.GA18422@kroah.com> <4F1E5B88.50801@compulab.co.il> <20120124165204.GB26552@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012, Greg KH wrote:

> On Tue, Jan 24, 2012 at 09:19:36AM +0200, Igor Grinberg wrote:
> > Hi Greg,
> > 
> > On 01/24/12 04:40, Greg KH wrote:
> > > #include <stable/formletter.h>
> > > #define RELEASE		3.2.2-rc1
> > > #define NUM_PATCHES	129
> > > #define RESPONSE_DATE	"Wed, Jan 25, 2012 20:00:00 +0000"
> > > #define LOCATION	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.2-rc1.gz
> > > 
> > > diffstat below, no one really reads these things anyway...
> > 
> > This is not exactly true...
> > I'm (and I think I'm not the only one) going through the diffstat
> > to see if there are any files of my interest involved,
> > because it is not always straight forward to understand what
> > the patch subject means and also there are too many of them to read all...
> > So, for me, the compromise between being updated on important issues
> > and spend not too much time reading patches subjects/message is
> > read the diffstat and if I find anything that is of my interest,
> > then go to the patches...
> > May be not the best, but works for me...
> 
> Sorry, I didn't mean to imply that no one reads the diffstat, I ment the
> other generic wording that I've had in the announcement emails for the
> past 6 years.
> 
> Glad it's still useful for you.
> 
I find it useful as well..

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

