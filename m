Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1E0Rw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:52:26 -0400
Received: from mail.lang.hm ([64.81.33.126]:38918 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1E0RwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:52:24 -0400
Date: Fri, 27 May 2011 10:51:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Theodore Tso <tytso@MIT.EDU>
cc: "D. Jansen" <d.g.jansen@googlemail.com>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
Message-ID: <alpine.DEB.2.02.1105271050160.30828@asgard.lang.hm>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com> <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu>
 <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com> <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com> <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
 <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, Theodore Tso wrote:

> If you are willing to rewrite the *entire* database to a completely new file each
> time you want to write out some data, and only delete the old database
> once the new database has been written out, then you're fine.   If the file is too
> big you can delay the time period between a complete writeout of the
> database.  But then if you drop your laptop and the battery slips out, you'll
> lose more data.  Life is full of tradeoffs.

actually, even in this case don't you need a barrier or fsync to make sure 
the new file is completely written before the old file goes away?

David Lang
