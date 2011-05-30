Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1E3SDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:03:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:60215 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab1E3SDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:03:51 -0400
Date: Mon, 30 May 2011 11:03:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: Oliver Neukum <oneukum@suse.de>, "D. Jansen" <d.g.jansen@googlemail.com>,
        Theodore Tso <tytso@mit.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <148710.1306760150@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.2.02.1105301102110.5766@asgard.lang.hm>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm>            <201105300913.27971.oneukum@suse.de>
 <148710.1306760150@turing-police.cc.vt.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, Valdis.Kletnieks@vt.edu wrote:

> On Mon, 30 May 2011 09:13:27 +0200, Oliver Neukum said:
>> Am Montag, 30. Mai 2011, 03:53:18 schrieb david@lang.hm:
>
>>> if what you are wanting is the ability to say 'these things must be
>>> written before these other things to keep them from being corrupted, but I
>>> don't care when they get written (or if they get lost in a crash)' then
>>> what you want isn't fsync, it's a barrier.
>>
>> Yes, but where is the problem?
>
> The problem is that *from userspace*, the closest approximation to a barrier
> is fsync().

good point, there really should be some way of doing a barrier from 
userspace.

David Lang
