Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2EFBAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 21:00:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57018 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab2EFBAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 21:00:39 -0400
Message-ID: <4FA5CD15.10503@zytor.com>
Date: Sat, 05 May 2012 18:00:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: "Ted Ts'o" <tytso@mit.edu>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] open(2): document O_PATH
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org> <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com> <877gwxacti.fsf@skywalker.in.ibm.com> <20120430114410.GB28308@thunk.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu) <87fwbhhdp2.fsf@skywalker.in.ibm.com>
In-Reply-To: <87fwbhhdp2.fsf@skywalker.in.ibm.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 01:27 AM, Aneesh Kumar K.V wrote:
> 
> fstat won't work, but fstatat with an empty path name would work.

Why the h... make *such* a distinction?

	-hpa

