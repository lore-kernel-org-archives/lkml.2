Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab2FOBsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:48:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:33650 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab2FOBsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:48:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165890511"
Date: Fri, 15 Jun 2012 09:48:35 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: automated warning notifications
Message-ID: <20120615014835.GA5695@localhost>
References: <20120614172523.GB4400@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614172523.GB4400@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, Jun 14, 2012 at 08:25:23PM +0300, Dan Carpenter wrote:
> Hi Fengguang,
> 
> I also check new static checker warnings and sometimes email people.

That would be nice!

> I wonder if we are duplicating each others work.  For example, did
> you send an email asking about the following Sparse warning:
> 
> sound/soc/codecs/ab8500-codec.c:1959:53: warning: cast truncates bits from constant value (1013 becomes 13)

I did try sending out sparse warnings to people, some time ago...

> Quite often those messages are false positive and the value is
> truncated deliberately.  In this case it looks suspicious and I
> would maybe email about it.  If I knew what kind of messages you
> check and which you ignore that would help me.

The lots of false warnings are a big problem. It makes the automated
notification more noises than signals to people. So I end up disabling
the sparse check totally..

These days I only send out gcc errors/warnings to the commit author,
committer, signers and relevant mailing lists reported by
scripts/get_maintainer.pl (but minus LKML).

> Perhaps there is an email list I could subscribe to to see if you
> had already sent a message.

In an average working day, 1-2 build errors will be caught and email
notified. I guess there will be more sparse warnings if it's turned
on.

Perhaps the sparse warnings can be enabled, but only sent to the patch
author. If you and anyone else are interested, they could be sent to
some mailing list, too. One thing I'm sure is, we probably never want
to disturb the busy maintainers with these warnings.

Thanks,
Fengguang
