Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab1KCQtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:49:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:65383 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891Ab1KCQte convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:9:1>);
	Thu, 3 Nov 2011 12:49:34 -0400
Message-Id: <4EB2D427020000780005ED64@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 03 Nov 2011 16:49:27 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: "Neo Jia" <cyclonusj@gmail.com>, <levinsasha928@gmail.com>,
        "JeremyFitzhardinge" <jeremy@goop.org>, <linux-mm@kvack.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Seth Jennings" <sjenning@linux.vnet.ibm.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Chris Mason" <chris.mason@oracle.com>,
        "Konrad Wilk" <konrad.wilk@oracle.com>, <ngupta@vflare.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
In-Reply-To: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.10.11 at 20:52, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> Hi Linus --
> 
> Frontswap now has FOUR users: Two already merged in-tree (zcache
> and Xen) and two still in development but in public git trees
> (RAMster and KVM).  Frontswap is part 2 of 2 of the core kernel
> changes required to support transcendent memory; part 1 was cleancache
> which you merged at 3.0 (and which now has FIVE users).
> 
> Frontswap patches have been in linux-next since June 3 (with zero
> changes since Sep 22).  First posted to lkml in June 2009, frontswap 
> is now at version 11 and has incorporated feedback from a wide range
> of kernel developers.  For a good overview, see
>    http://lwn.net/Articles/454795.
> If further rationale is needed, please see the end of this email
> for more info.
> 
> SO... Please pull:
> 
> git://oss.oracle.com/git/djm/tmem.git #tmem
> 
>...
> Linux kernel distros incorporating frontswap:
> - Oracle UEK 2.6.39 Beta:
>    http://oss.oracle.com/git/?p=linux-2.6-unbreakable-beta.git;a=summary 
> - OpenSuSE since 11.2 (2009) [see mm/tmem-xen.c]
>    http://kernel.opensuse.org/cgit/kernel/ 

I've been away so I am too far behind to read this entire
very long thread, but wanted to confirm that we've been
carrying an earlier version of this code as indicated above
and it would simplify our kernel maintenance if frontswap
got merged.  So please count me as supporting frontswap.

Thanks, Jan

> - a popular Gentoo distro
>    http://forums.gentoo.org/viewtopic-t-862105.html 
> 
> Xen distros supporting Linux guests with frontswap:
> - Xen hypervisor backend since Xen 4.0 (2009)
>    http://www.xen.org/files/Xen_4_0_Datasheet.pdf 
> - OracleVM since 2.2 (2009)
>    http://twitter.com/#!/Djelibeybi/status/113876514688352256 
> 
> Public visibility for frontswap (as part of transcendent memory):
> - presented at OSDI'08, OLS'09, LCA'10, LPC'10, LinuxCon NA 11, Oracle
>   Open World 2011, two LSF/MM Summits (2010,2011), and three
>   Xen Summits (2009,2010,2011)
> - http://lwn.net/Articles/454795 (current overview)
> - http://lwn.net/Articles/386090 (2010)
> - http://lwn.net/Articles/340080 (2009)



