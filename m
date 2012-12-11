Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2LKTsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:48:55 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:34320 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2LKTsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:48:54 -0500
Message-ID: <1355255320.2356.148.camel@falcor>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@parisplace.org>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Date: Tue, 11 Dec 2012 14:48:40 -0500
In-Reply-To: <CA+55aFwG31fi9=r0Zta2hoo60vdgM61hbh4BC9Rgs8i7S82Haw@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	 <1355234914.2356.85.camel@falcor>
	 <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	 <1355249884.2356.108.camel@falcor>
	 <CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
	 <1355252392.2356.131.camel@falcor>
	 <CA+55aFwG31fi9=r0Zta2hoo60vdgM61hbh4BC9Rgs8i7S82Haw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121119-7408-0000-0000-00000AF1135D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 11:10 -0800, Linus Torvalds wrote:

> Anyway, the whole "you can do it at file granularity" isn't the bulk
> of my argument (the "we already have the field that makes sense" is).
> But my point is that per-inode is not only the logically more
> straightforward place to do it, it's also the much more flexible place
> to do it. Because it *allows* for things like that.

Ok. To summarize, S_IMA indicates that there is a rule and that the iint
was allocated.  To differentiate between 'haven't looked/don't know' and
'definitely not', we need another bit.  For this, you're suggesting
using IS_PRIVATE()?  Hopefully, I misunderstood.

thanks,

Mimi



