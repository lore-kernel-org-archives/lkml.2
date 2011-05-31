Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab1EaMiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:38:15 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:46886 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1EaMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:38:14 -0400
Date: Tue, 31 May 2011 14:38:11 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Turning off the incremental diff robot
Message-ID: <20110531123811.GA2457@osiris.boeblingen.de.ibm.com>
References: <4DE3E9E7.8020008@zytor.com>
 <20110530194500.GE10792@home.goodmis.org>
 <4DE402BD.4060407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE402BD.4060407@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 01:49:01PM -0700, H. Peter Anvin wrote:
> On 05/30/2011 12:45 PM, Steven Rostedt wrote:
> > On Mon, May 30, 2011 at 12:03:03PM -0700, H. Peter Anvin wrote:
> >> Hi all,
> >>
> >> With the v3.0 name change I was looking over what might break, and I'm
> >> seriously considering turning off the incremental diff robot on
> >> kernel.org.  It's not clear to me that it is actually useful anymore,
> >> with git and all.
> > 
> > What is the incremental diff robot?
> > 
> > Does it make the patches between 2.6.x to 2.6.x+1?
> > 
> 
> No, but it generates the patches between, say, 2.6.x.y and 2.6.x.y+1 or
> 2.6.x-rcy and 2.6.x-rcy+1.  Anything in an "incr" directory.

Yep, I use those incremental patches over here.
