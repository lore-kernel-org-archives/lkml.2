Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2KVVkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:40:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42240 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab2KVVj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:39:59 -0500
X-Greylist: delayed 1246 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 16:39:59 EST
User-Agent: K-9 Mail for Android
In-Reply-To: <20121121191542.GA23422@kroah.com>
References: <20121120235659.95001487.akpm@linux-foundation.org> <20121121184146.A9BCB8013C@viridian.itc.virginia.edu> <20121121191542.GA23422@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Nov 2012 23:55:05 +0000
To: Greg KH <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <99207e4d-1982-42da-9a4a-9df91d719eb5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH <gregkh@linuxfoundation.org> wrote:

>On Wed, Nov 21, 2012 at 01:41:46PM -0500, Bill Pemberton wrote:
>> Andrew Morton writes:
>> > 
>> > On Tue, 20 Nov 2012 10:46:11 +0000 Grant Likely
><grant.likely@secretlab.ca> wrote:
>> > 
>> > > On Sat, Nov 17, 2012 at 12:19 AM, Bill Pemberton
><wfp5p@virginia.edu> wrote:
>> > > > CONFIG_HOTPLUG is no longer an optional setting.  In order to
>remove
>> > > > it as on option code paths that check CONFIG_HOTPLUG will
>removed
>> > > > along with the attributes __devexit_p, __devexit,
>__devinitconst, and
>> > > > __devinitdata.
>> > > >
>> > > > I'll save the list from the mailbomb of this huge patchset. 
>The
>> > > > patches themselves are going to Greg KH for the driver core
>tree.
>> > > >
>> > > >
>> > > > Bill Pemberton (493):
>> > > [...]
>> > > >  2942 files changed, 11645 insertions(+), 12116 deletions(-)
>> > > 
>> > > So, I've got no problem with the reason for the change and I
>don't
>> > > even think you need my ack for the bits that I maintain (though
>you
>> > > have it if you want it). However, this looks like it is going to
>be
>> > > /painful/. First of all it will touch a huge number of files in
>the
>> > > tree. Yes the change is trivial, but it will require manual
>fixups on
>> > > a lot of patches.
>> > 
>> > Yeah, this is dopey.  Send the script to Linus and ask him to run
>it
>> > seven seconds before he releases -rc1, when everyone's trees are
>> > empty(ish).  Or send him a single megapatch at that time.
>> > 
>> 
>> I like the script idea for removing all the __dev markings.  Creating
>> the patches in the first place was a game of whack-a-mole as various
>> trees changed.

You mean this series wasn't created with a script? You did this by hand? If so then I must say kudos on your dedication!

But it makes me more nervous about the series. Too easy to fat finger many things when touching that many files.

Please do write a script and post that for review.

g.

>
>Linus doesn't like to take scripts, I had planned on queueing all of
>these up that different subsystems maintainers didn't take, and pushing
>the ones that did merge cleanly into -rc1.  Then, right after -rc1 is
>out, go through the tree once more to get the stragglers.
>
>Sound reasonable?
>
>thanks,
>
>greg k-h

-- 
Grant Likely, P.Eng.
Secret Lab Technologies Ltd.
