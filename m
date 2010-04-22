Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0DVJMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 05:12:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41648 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752570Ab0DVJMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 05:12:33 -0400
Date: Thu, 22 Apr 2010 10:17:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's the staging review and acceptance process?
Message-ID: <20100422101708.69c90142@lxorguk.ukuu.org.uk>
In-Reply-To: <20100422054902.GA28037@suse.de>
References: <1271881967.1730.482.camel@Joe-Laptop.home>
	<20100422034532.GA25177@suse.de>
	<1271910357.1730.627.camel@Joe-Laptop.home>
	<20100422054902.GA28037@suse.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 22:49:02 -0700
Greg KH <gregkh@suse.de> wrote:

> On Wed, Apr 21, 2010 at 09:25:57PM -0700, Joe Perches wrote:
> > On Wed, 2010-04-21 at 20:45 -0700, Greg KH wrote:
> > > That caused the huge backlog staring at
> > > me right now.
> > 
> > Which likely discouraged the new contributors who
> > submitted stuff still in that backlog.
> 
> While a series of unfortunate events did happen to cause this, do you
> have any evidence of this causing people to go away? 

Subjectively the answer is yes I think. More quantatively it was the case.
I did some measurements long ago with 2.4-ac and there was direct and
clear connection between two things and patch submission/activity levels.
One was 'cycle time' (ie time from submit->response->tree) - the other was
putting the name of the contributor in the per -ac patch summaries that
used to get mailed out.


Alan
