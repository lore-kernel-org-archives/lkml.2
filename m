Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab2ECNHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:07:30 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55078 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab2ECNH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:07:27 -0400
Date: Thu, 3 May 2012 09:07:07 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] open(2): document O_PATH
Message-ID: <20120503130707.GF18002@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
	Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
	viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
	lkml <linux-kernel@vger.kernel.org>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
 <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com>
 <877gwxacti.fsf@skywalker.in.ibm.com>
 <20120430114410.GB28308@thunk.org>
 <87fwbhhdp2.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwbhhdp2.fsf@skywalker.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:57:21PM +0530, Aneesh Kumar K.V wrote:
> 
> fstat won't work, but fstatat with an empty path name would work. O_PATH
> descriptors are suppose to be used as "location only descriptors". 
> We then extended the *at syscalls to work with EMPTY pathnames so that
> O_PATH descriptors can be used with readlink, fchownat and fstatat().
> This was done to enable us to do these operation on symlinks.
> (65cfc6722361570bfe255698d9cd4dccaf47570d)

Could you define explicitly what you mean by "EMPTY" pathnames?  Do
you mean a path name that doesn't exist?  (i.e., one of the
directories specified in the pathname does not currently exist in the
directory hierarchy visible to the process).

					- Ted

