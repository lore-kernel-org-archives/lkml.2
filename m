Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1KDItL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:49:11 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47714 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1KDItJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:9:1>);
	Fri, 4 Nov 2011 04:49:09 -0400
Message-Id: <4EB3B52E020000780005EF43@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 04 Nov 2011 08:49:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Neo Jia" <cyclonusj@gmail.com>, <levinsasha928@gmail.com>,
        "JeremyFitzhardinge" <jeremy@goop.org>, <linux-mm@kvack.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Seth Jennings" <sjenning@linux.vnet.ibm.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Chris Mason" <chris.mason@oracle.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        "Konrad Wilk" <konrad.wilk@oracle.com>, <ngupta@vflare.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <4EB2D427020000780005ED64@nat28.tlf.novell.com>
 <20111103175410.b15efb8c.akpm@linux-foundation.org>
In-Reply-To: <20111103175410.b15efb8c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.11.11 at 01:54, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 03 Nov 2011 16:49:27 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> >>> On 27.10.11 at 20:52, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>> > Hi Linus --
>> > 
>> > Frontswap now has FOUR users: Two already merged in-tree (zcache
>> > and Xen) and two still in development but in public git trees
>> > (RAMster and KVM).  Frontswap is part 2 of 2 of the core kernel
>> > changes required to support transcendent memory; part 1 was cleancache
>> > which you merged at 3.0 (and which now has FIVE users).
>> > 
>> > Frontswap patches have been in linux-next since June 3 (with zero
>> > changes since Sep 22).  First posted to lkml in June 2009, frontswap 
>> > is now at version 11 and has incorporated feedback from a wide range
>> > of kernel developers.  For a good overview, see
>> >    http://lwn.net/Articles/454795.
>> > If further rationale is needed, please see the end of this email
>> > for more info.
>> > 
>> > SO... Please pull:
>> > 
>> > git://oss.oracle.com/git/djm/tmem.git #tmem
>> > 
>> >...
>> > Linux kernel distros incorporating frontswap:
>> > - Oracle UEK 2.6.39 Beta:
>> >    http://oss.oracle.com/git/?p=linux-2.6-unbreakable-beta.git;a=summary 
>> > - OpenSuSE since 11.2 (2009) [see mm/tmem-xen.c]
>> >    http://kernel.opensuse.org/cgit/kernel/ 
>> 
>> I've been away so I am too far behind to read this entire
>> very long thread, but wanted to confirm that we've been
>> carrying an earlier version of this code as indicated above
>> and it would simplify our kernel maintenance if frontswap
>> got merged.  So please count me as supporting frontswap.
> 
> Are you able to tell use *why* you're carrying it, and what benefit it
> is providing to your users?

Because we're supporting/using Xen, where this (within the general
tmem picture) allows for better overall memory utilization.

Jan

