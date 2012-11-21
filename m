Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2KVVej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:34:39 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57371 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2KVVed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:34:33 -0500
MIME-Version: 1.0
In-Reply-To: <20121120235659.95001487.akpm@linux-foundation.org>
References: <1353112043-11800-1-git-send-email-wfp5p@virginia.edu>
 <CACxGe6ss3HsnGgNn=aOJsd0-6q-dRumPvkKdqjKWCFja9QDgtQ@mail.gmail.com> <20121120235659.95001487.akpm@linux-foundation.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Nov 2012 23:05:20 +0000
X-Google-Sender-Auth: pCAHnFinoWzfJxxO5ehqDh8iTxk
Message-ID: <CACxGe6ubsSdnmdB_RYcdOnaWRNAki-HS0NW0ApFL2o=_CgynyQ@mail.gmail.com>
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 7:56 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 20 Nov 2012 10:46:11 +0000 Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> On Sat, Nov 17, 2012 at 12:19 AM, Bill Pemberton <wfp5p@virginia.edu> wrote:
>> > CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
>> > it as on option code paths that check CONFIG_HOTPLUG will removed
>> > along with the attributes __devexit_p, __devexit, __devinitconst, and
>> > __devinitdata.
>> >
>> > I'll save the list from the mailbomb of this huge patchset.  The
>> > patches themselves are going to Greg KH for the driver core tree.
>> >
>> >
>> > Bill Pemberton (493):
>> [...]
>> >  2942 files changed, 11645 insertions(+), 12116 deletions(-)
>>
>> So, I've got no problem with the reason for the change and I don't
>> even think you need my ack for the bits that I maintain (though you
>> have it if you want it). However, this looks like it is going to be
>> /painful/. First of all it will touch a huge number of files in the
>> tree. Yes the change is trivial, but it will require manual fixups on
>> a lot of patches.
>
> Yeah, this is dopey.  Send the script to Linus and ask him to run it
> seven seconds before he releases -rc1, when everyone's trees are
> empty(ish).  Or send him a single megapatch at that time.

Yes please. I'm all on board with doing this in one fell swoop.

g.



--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
