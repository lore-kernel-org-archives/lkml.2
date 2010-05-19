Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0ESHWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:22:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26960 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0ESHWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:22:45 -0400
Date: Wed, 19 May 2010 09:59:34 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext James Bottomley <James.Bottomley@suse.de>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100519065934.GH12879@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1274115885.4418.59.camel@mulgrave.site>
 <20100517174647.GA11512@gandalf>
 <1274119179.4418.68.camel@mulgrave.site>
 <20100517181252.GA14260@gandalf>
 <1274124267.4418.149.camel@mulgrave.site>
 <20100517193840.GB14047@gandalf>
 <20100517193952.GC14047@gandalf>
 <1274125775.4418.182.camel@mulgrave.site>
 <20100518064022.GA6522@nokia.com>
 <1274191188.10304.5.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1274191188.10304.5.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 May 2010 07:01:39.0887 (UTC) FILETIME=[2157E3F0:01CAF721]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 03:59:48PM +0200, ext James Bottomley wrote:
>On Tue, 2010-05-18 at 09:40 +0300, Felipe Balbi wrote:
>> On Mon, May 17, 2010 at 09:49:35PM +0200, ext James Bottomley wrote:
>> >Right, because Firmware writers are from the rugged unresponsive uplands
>> >of planet
>> >ignore-user-complaints-and-eat-them-for-breakfast-if-they-file-bugs and
>> >Software writers are from the emollient responsive groves of planet
>> >harmony.  Obviously what would work for one wouldn't work for the other.
>> >
>> >As a software writer, I fully buy into that world view.  The trouble is
>> >that when I go to dinner with hardware people, they seem to be awfully
>> >nice chaps ... almost exactly like me, in fact ...
>>
>> what does this add to suspend_blockers discussion ?
>
>Sorry I was evidently being too subtle.
>
>The point is that if, as you acknowledge, that you can't train firmware
>engineers to be responsive, there's no reason to think you can train
>software engineers in the same quality ... they're very similar people.

I wouldn't say it's up to the engineer himself, it's more related to how 
the company that person works for deal with such things.

>The corollary is that real world systems have to operate in the face of
>misbehaving hardware *and* software.

I still think the kernel shouldn't deal with broken applications and we 
shouldn't try to fix them in kernel space. We can, of course, try to 
find them and have all sorts of bells and whistles shouting 'process 
%s is preventing CPU from sleeping for %llu nanoseconds' or something 
like that.

-- 
balbi

DefectiveByDesign.org
