Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0DVJZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 05:25:45 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38941 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0DVJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 05:25:44 -0400
Message-ID: <4BD015F0.5090901@s5r6.in-berlin.de>
Date: Thu, 22 Apr 2010 11:25:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.24) Gecko/20100228 SeaMonkey/1.1.19
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's the staging review and acceptance process?
References: <1271881967.1730.482.camel@Joe-Laptop.home>	 <20100422034532.GA25177@suse.de>	 <1271910357.1730.627.camel@Joe-Laptop.home>	 <20100422054902.GA28037@suse.de> <1271915718.1730.687.camel@Joe-Laptop.home>
In-Reply-To: <1271915718.1730.687.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/2010 7:55 AM, Joe Perches wrote:
> On Wed, 2010-04-21 at 22:49 -0700, Greg KH wrote:
>> On Wed, Apr 21, 2010 at 09:25:57PM -0700, Joe Perches wrote:
>> > On Wed, 2010-04-21 at 20:45 -0700, Greg KH wrote:
>> > > That caused the huge backlog staring at me right now.
>> > Which likely discouraged the new contributors who
>> > submitted stuff still in that backlog.
>> do you have any evidence of this causing people to go away?
> 
> I think it's pretty established that response delays
> cause losses of one type or another.

Perhaps, perhaps not.  OTOH, the development process documentation
contains the advice not to be discouraged if feedback isn't immediate,
and if in doubt, simply resubmit sometime later.
http://lxr.linux.no/#linux-old+v2.4.0/Documentation/SubmittingPatches#L180
I.e. it is well known that delays may happen and that people should not
worry about them.

If people /do/ get discouraged nevertheless, then this is because they
do not want or cannot afford to spend the (little) time to resubmit or
just ask what the review progress is.  If this happened to a bug fix of
an existing feature, than that is sad and our loss.  But if this
happened to a patch that is meant to develop a new feature --- such as
fundamentally all patches to drivers/staging/ --- then there is not any
real loss of a potential contributor, IMO:  Mid-term or long-term
contributors need to be people who work with the reviewers and
maintainers, and that means to cope with occasional delays.

Of course, if there is a subsystem with _permanent_ huge delays or
actual patch loss or is orphaned entirely, then somebody needs to step
in and offer help with review (which is a hard task and only worthwhile
if the volunteering reviewer is credible) and perhaps with maintenance
duties (which is easier).
-- 
Stefan Richter
-=====-==-=- -=-- =-==-
http://arcgraph.de/sr/
