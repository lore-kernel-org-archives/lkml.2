Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1BHQew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:34:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42440 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1BHQev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:34:51 -0500
MIME-Version: 1.0
Message-ID: <e908a602-35b8-4ecc-aad2-8973da171161@default>
Date: Tue, 8 Feb 2011 08:30:57 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, Chris Mason <chris.mason@oracle.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        sfr@canb.auug.org.au, wfg@mail.ustc.edu.cn, tytso@mit.edu,
        viro@ZenIV.linux.org.uk, hughd@google.com, hannes@cmpxchg.org
Subject: RE: [PATCH V1 3/3] drivers/staging: kztmem: misc build/config
References: <20110118172151.GA20507@ca-server1.us.oracle.com
 20110204212843.GA18924@kroah.com>
In-Reply-To: <20110204212843.GA18924@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D517038.00E1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Subject: Re: [PATCH V1 3/3] drivers/staging: kztmem: misc build/config
> 
> On Tue, Jan 18, 2011 at 09:21:51AM -0800, Dan Magenheimer wrote:
> > [PATCH V1 3/3] drivers/staging: kztmem: misc build/config
> >
> > Makefiles and Kconfigs to build kztmem in drivers/staging
> >
> > There is a dependency on xvmalloc.* which in 2.6.37 resides
> > in drivers/staging/zram.  Should this move or disappear,
> > some Makefile/Kconfig changes will be required.
> 
> There is some other kind of dependancy as well, because I get the
> following errors when building:
> : 
> If you require a kbuild dependancy, then put it in your Kconfig file
> please, don't break the build.
> 
> I'll not apply these patches for now until that's fixed up.
> 
> thanks,
> greg k-h

Hi Greg --

Just wanted to confirm that this is now fixed and hope that you
can now apply BUT note that per agreement with Nitin Gupta [1]
the patchset has been modified to be named zcache and the
renamed patchset (with the proper kbuild dependency) has been
posted at [2].

ALSO, could you please confirm the path by which this patchset
will find its way upstream?  I see from your blog [3] that after
you apply it, I should be able to see it in sfr's linux-next
tree [4] which IIUC sfr pulls regularly from your staging-next
tree [5].  And I think at the next merge window, YOU will
provide the pull request to Linus included with any other
staging drivers?  Is this all correct?

Sorry for the driver-staging-newbie question but your blog
entry is 2 years old and I'd like to (1) ensure that I don't
drop some important task *I* still need to do and (2) be able
to track the progress of zcache through the various trees as
a self-educational exercise.

Thanks,
Dan

[1] https://lkml.org/lkml/2011/2/5/181 
[2] https://lkml.org/lkml/2011/2/6/346
    https://lkml.org/lkml/2011/2/6/345 
    https://lkml.org/lkml/2011/2/6/344 
    https://lkml.org/lkml/2011/2/6/343 
[3] http://www.kroah.com/log/linux/linux-staging-update.html 
[4] http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git 
[5] http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=shortlog;h=refs/heads/staging-next
