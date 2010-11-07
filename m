Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0KGD0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 23:26:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52834 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0KGD0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 23:26:39 -0400
Subject: Re: [GIT] HID
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <alpine.LNX.2.00.1010240816140.6879@pobox.suse.cz>
Date: Sat, 6 Nov 2010 23:26:34 -0400
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <436F4442-6174-4A5B-BB7F-5B7678AE5048@wilsonet.com>
References: <alpine.LNX.2.00.1010232314400.6879@pobox.suse.cz> <AANLkTikc74bA+OPJjhLUHu_mp59L=SKnPTXjPK=E28U5@mail.gmail.com> <alpine.LNX.2.00.1010240816140.6879@pobox.suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 24, 2010, at 2:19 AM, Jiri Kosina wrote:

> On Sat, 23 Oct 2010, Jarod Wilson wrote:
> 
>>> please pull from 'for-linus' branch at
>>> 
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
>>> 
>>> to receive the HID subsystem patches below. Mostly adding support for a
>>> few new multitouch toys, and improving already existing drivers. Plus some
>>> bugfixes which were not urgent enough for .36.
>> 
>> *cough*
>> 
>> https://patchwork.kernel.org/patch/161481/
>> 
>> What's a guy gotta do to get that patch merged too? :)
> 
> Bah, it's still pending in my TODO folder, sorry for that. I am not really 
> convinced whether it's the right aproach.
> 
> First, I'll go check HUT how much non-standard the usages you are adding 
> to generic code, are.

Just the four under HID_UP_TIVOVENDOR, I believe. Everything else should be bog-standard.

> Perhaps it would satisfy separate driver on the hid 
> bus?
> (Second, I hope to shovel all the 'drivers' which only do specialized 
> mappings into userspace/udev actually).

Yeah, I've heard that mentioned as Coming Soon(tm) for a while now though... ;)

Looks like the patch does require trivial massaging to apply now, I could do that and chop out the four vendor-specific usages and resubmit just the parts I believe are entirely in line with the HUT, then try to figure out what all is required on the udev side.

-- 
Jarod Wilson
jarod@wilsonet.com



