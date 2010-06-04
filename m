Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0FDTUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 15:20:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab0FDTUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 15:20:18 -0400
Date: Fri, 4 Jun 2010 12:19:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Support generic I/O requests
Message-Id: <20100604121957.d9bc55ae.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
	<1275379286-10453-2-git-send-email-ngupta@vflare.org>
	<AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 15:20:13 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> P.S)
> Why don't you send this series to -mm?
> I don't know any patches have to go linux-next and any patches have to
> go --mmotm.

The code lives in drivers/staging/ at present.  That's Greg's tree.

> I thought zram is related to memory management a little bit.
> 
> What's the criteria?

Yes, and this is something which bothers me a bit about the -staging
process.  Code gets in there largely under the radar of the people who
work in that area.  It gets "matured" for a while and the developer
thinks it's all ready to go into "mainline" and ....  then what? 
Someone needs to yank the code out of -staging and tell the interested
parties "hey, look at this".  And at this stage, they might say "hell
no", or request large changes and the developer who thought everything
was all ready to go would be justifiably upset.

Obviously, this hasn't happened (much) with zram (partly because I
happened to notice it), but the potential is there.

I'm not sure what a good solution is, really.  Obviously it would be
better if such code went straight into the subsystem maintainer's tree
on day one and got worked on there.  But if that process was working
efficiently, we wouldn't have ever needed ./staging/.

So I suppose we (ie: Greg ;)) should identify the destination
maintainer at the outset and make sure that the maintainer(s) and the
subsystem mailing list are kept in the loop on all developments, and
that they're aware that this code is headed their way.  Perhaps that's
already happening and I missed it.


