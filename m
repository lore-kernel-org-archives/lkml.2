Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab2C1Wti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:49:38 -0400
Received: from home.keithp.com ([63.227.221.253]:58996 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758801Ab2C1Wtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:49:31 -0400
From: Keith Packard <keithp@keithp.com>
To: Jiri Kosina <jkosina@suse.cz>, Dave Jones <davej@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: Corrupted files after suspend to disk
In-Reply-To: <alpine.LNX.2.00.1203290011230.25526@pobox.suse.cz>
References: <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de> <jj684d$6ng$1@ID-44327.news.uni-berlin.de> <CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com> <4F574113.8030906@01019freenet.de> <alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz> <CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com> <alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz> <CAFLxGvyXwFwLRYw7=eHGLZsiAB9Adcu16z=UPhLtL_Ze3bF-9g@mail.gmail.com> <alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz> <4F5DF8F0.5010801@01019freenet.de> <20120312214914.GA8628@redhat.com> <alpine.LNX.2.00.1203290011230.25526@pobox.suse.cz>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 28 Mar 2012 15:49:26 -0700
Message-ID: <868vikwdc9.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Thu, 29 Mar 2012 00:12:53 +0200 (CEST), Jiri Kosina <jkosina@suse.cz> wrote:

> So this keeps happening to me on almost every resume still ... Keith, is 
> there any way I could help you debug this?

Let me know what you find with Dave's patch -- it's the most promising
lead we've had. We've had no luck reproducing this at Intel, though a
couple of engineers have been trying to make it happen for several days
now...

-- 
keith.packard@intel.com
