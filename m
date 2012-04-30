Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab2D3Lov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:44:51 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:36754 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab2D3Lot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:44:49 -0400
Date: Mon, 30 Apr 2012 07:44:10 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] open(2): document O_PATH
Message-ID: <20120430114410.GB28308@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
	Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
	viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
	lkml <linux-kernel@vger.kernel.org>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
 <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com>
 <877gwxacti.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gwxacti.fsf@skywalker.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might also be a good idea to document explicitly whether or not
things like fstat() and the syscalls to manipulate extended attributes
are expected to work.

Thanks,

					- Ted
