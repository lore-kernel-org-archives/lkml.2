Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2K3Iaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:30:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45702 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2K3Iad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:30:33 -0500
Date: Fri, 30 Nov 2012 00:30:26 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Michal Marek <mmarek@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 036/270] kbuild: Do not package /boot and /lib in make
 tar-pkg
Message-ID: <20121130083026.GE28232@elie.Belkin>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-37-git-send-email-herton.krzesinski@canonical.com>
 <1353983187.4266.40.camel@deadeye.wl.decadent.org.uk>
 <20121130013843.GB13478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130013843.GB13478@kroah.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Tue, Nov 27, 2012 at 02:26:27AM +0000, Ben Hutchings wrote:
>> On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:

>>> commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.
>>>
>>> There were reports of users destroying their Fedora installs by a kernel
>>> tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
>>> toplevel directories from the tarball to prevent this from happening.
>>> 
>>> Reported-by: Andi Kleen <andi@firstfloor.org>
>>> Suggested-by: Ben Hutchings <ben@decadent.org.uk>
>>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>>> [ herton: dropped unrelated changes to arch/x86/Makefile and
>>>   scripts/Makefile.fwinst, which don't apply anyway on 3.5, see commit
>>>   3ce9e53e788881da0d5f3912f80e0dd6b501f304 upstream ]
>>> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
>>
>> This is missing from 3.4.
>
> I don't think it is needed, as 3ce9e53e788881da0d5f3912f80e0dd6b501f304
> didn't go into 3.4, so all should be good for now.

The dependency's the other way around.  Herton's comment above means
to say that 3ce9e53 is being squashed in as a fixup.

Thanks,
Jonathan
