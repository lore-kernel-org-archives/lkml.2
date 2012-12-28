Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2L1Vbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:31:42 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51171 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754080Ab2L1Vbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:31:40 -0500
Message-ID: <1356730299.31130.27.camel@joe-AO722>
Subject: Re: how to look for source code in kernel
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        anish singh <anish198519851985@gmail.com>,
        amit mehta <gmate.amit@gmail.com>,
        Henrique Rodrigues <henriquesilvar@gmail.com>,
        kishore kumar <kishoreopen@gmail.com>,
        Jonathan Neusch??fer <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
Date: Fri, 28 Dec 2012 13:31:39 -0800
In-Reply-To: <20121228160927.GY4939@ZenIV.linux.org.uk>
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com>
	 <20121227184034.GA2982@debian.debian>
	 <CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com>
	 <CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
	 <CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com>
	 <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com>
	 <87a9syhbma.fsf@xmission.com> <20121228160927.GY4939@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 16:09 +0000, Al Viro wrote:
> On Thu, Dec 27, 2012 at 11:36:13PM -0800, Eric W. Biederman wrote:
> > But then I am probably peculiar keeping an index of the source code in
> > my head.  When I need to look for something and I don't know where to
> > find it I do.
> > 
> > git-ls-files | xargs fgrep 'struct f2fs_inode'
> 
> What's wrong with git grep?

Positive: it loads multiple cpus with very little file I/O
Negative: it doesn't use -P very well.
          it won't spans lines like:

	struct name
	{

with git grep -P "\bstruct\s+\w+\s*{"

(the last grep that does I believe is 2.54)


