Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab2JYIMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:12:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51149 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2JYIMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:12:44 -0400
X-AuditID: cbfee61b-b7f616d00000319b-71-5088f47aedcd
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182055.GA6096@kroah.com> <20121023191135.GA1623@kroah.com>
In-reply-to: <20121023191135.GA1623@kroah.com>
Subject: RE: [PATCH 0/3] f2fs: move proc files to debugfs
Date: Thu, 25 Oct 2012 17:12:41 +0900
Message-id: <005f01cdb288$8189a3b0$849ceb10$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2xUjlGF5puENIXQ/y2iIjoG/kVDwBHw1Ag
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zI92qLx0BBgtfylvs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWs2jaFrWCpQMWEJbvZGxhP8XQxcnJICJhIbOubygZh
	i0lcuLceyObiEBJYxihx6Pkddpii7s8foRKLGCVu/r7PDuH8Y5S4u2sTkMPBwSagLbF5vwFI
	g4iAlsSzYzuYQWqYBQ4zSnx6tJgFJCEk0MwoMeGyOYjNKaAncX3WAUYQW1jAUmLbjC6wM1gE
	VCVenJwGtplXwFbi6tuJULagxI/J91hAdjED9d6/qAUSZhaQl9i85i0zSFhCQF3i0V9diBOM
	JDY13meGKBGXmPTgITvEdAGJb5MPsUCUy0psOsAM8eI6dok1xwogbEmJgytusExglJiFZO8s
	hL2zkOydhWTBAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxgh8SW9g3FVg8UhRgEORiUe
	3oMeHQFCrIllxZW5hxglOJiVRHi3vwcK8aYkVlalFuXHF5XmpBYfYvQBunsis5Rocj4w9vNK
	4g2NjU3MTExNzC1NzU1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYEzdJHMz/rSq4RZ+
	3gcq6Ynsv0y+T3s0Z9U3o2/80m/2SnL3GTxYHcvO3/XAj1/uQrPNI8vo4gW7jnXV2JZUf3We
	dDbSefdDXqfAmX9nsxn+YJATPN3T+Cfffd/1SXN9/7wSOKxpXvxRiin112OtqLIpE7adDteK
	uyXZ0h34fFvc+1slXNts7iixFGckGmoxFxUnAgA95V2T3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd2qLx0BBlfvSFvs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrNo2ha1gqUDF
	hCW72RsYT/F0MXJySAiYSHR//sgGYYtJXLi3Hsjm4hASWMQocfP3fXYI5x+jxN1dm4AcDg42
	AW2JzfsNQBpEBLQknh3bwQxSwyxwmFHi06PFLCAJIYFmRokJl81BbE4BPYnrsw4wgtjCApYS
	22Z0gW1jEVCVeHFyGjuIzStgK3H17UQoW1Dix+R7LCC7mIF671/UAgkzC8hLbF7zlhkkLCGg
	LvHory7ECUYSmxrvM0OUiEtMevCQfQKj0Cwkg2YhDJqFZNAsJB0LGFlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgTH7zPpHYyrGiwOMQpwMCrx8B706AgQYk0sK67MPcQowcGsJMK7/T1Q
	iDclsbIqtSg/vqg0J7X4EKMP0JsTmaVEk/OBqSWvJN7Q2MTMyNLIzMLIxNwch7CSOG+zR0qA
	kEB6YklqdmpqQWoRzDgmDk6pBsbQrv3ad7Xur2XQ+Nz82TFF/bGfvNFZlWRTxaI/5gapiTVP
	48K10kW6X0Qc9KlZduvhvn9ZDvc/qDyMnXIle9nxI7k7dp61eLIq/9neZXEx0gz/xd8c/7i2
	mmHV0TOzFm3scYr5/uDsxpZW6Z7CfsnHzX0h1rNWTBbn4Xs9r4Tlxxvnz7b/7USUWIozEg21
	mIuKEwGiyJltDAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 23, 2012 at 11:20:55AM -0700, Greg KH wrote:
> > Here are 3 patches, moving the proc file usage on f2fs to debugfs.
> >
> > The first one fixes a bug in the gc.h file preventing it from being able
> > to be included by any other files.
> >
> > The second patch moves all current proc file accesses to a single file,
> > removing all #ifdefs from the .c files.  This should have been done in
> > the first place.
> >
> > The last file converts the files to use debugfs instead of proc.
> >
> > Note, these patches have been compile tested only, I haven't tested them
> > out, as I haven't had the chance to yet.  I'll go do that this afternoon
> > after I catch up on some other pending kernel work.
> >
> > One question, it seems that the proc files show all information for all
> > super blocks in the system, no matter which subdirectory you are reading
> > from in the proc f2fs tree.  Is that really what you want?  Shouldn't we
> > only be showing the stats of the superblock we are saying we will
> > report?  I'll test that later today, and if it really is wrong, will fix
> > the debugfs code up to handle this properly.
> 
> I just tested your patch set, and it looks like I see all partition
> information in each file, no matter what subdir it is in.
> 
> So, do you want this to be broken up per partition/superblock, in a
> subdir, like you intended?  Or just 3 files, for all superblocks in the
> system?

Thank you for great patches. I really appreciate that.
When I merged your patches, I found some unnecessary codes and memory
structures such as gc_info in the original codes.
So I've done some works additionally based on the patches.
Furthermore, for readability, I merged 3 stat files into one file, and
let it show all the superblocks together, no breakdown per partition.
I'll submit v3-series applying these changes soon.
Thanks,

> 
> Oh, the third patch is buggy, don't apply it, I got the subdir logic
> wrong, I'll go fix that up now.
> 
> thanks,
> 
> greg k-h


---
Jaegeuk Kim
Samsung


