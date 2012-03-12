Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2CLV4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:56:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62792 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab2CLV43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120312214914.GA8628@redhat.com>
References: <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de>
	<jj684d$6ng$1@ID-44327.news.uni-berlin.de>
	<CAFLxGvwazkbisZ0Ax==-Yyv2h5mYtnK-S2bOegZHX5g+rB2krQ@mail.gmail.com>
	<4F574113.8030906@01019freenet.de>
	<alpine.LRH.2.00.1203121300590.4911@twin.jikos.cz>
	<CAFLxGvwv159LHtyKdrF1DQZ-vQyagLJ9nNkcAZzkY4O9F-MwNg@mail.gmail.com>
	<alpine.LNX.2.00.1203121329430.18356@pobox.suse.cz>
	<CAFLxGvyXwFwLRYw7=eHGLZsiAB9Adcu16z=UPhLtL_Ze3bF-9g@mail.gmail.com>
	<alpine.LNX.2.00.1203121402460.18356@pobox.suse.cz>
	<4F5DF8F0.5010801@01019freenet.de>
	<20120312214914.GA8628@redhat.com>
Date: Mon, 12 Mar 2012 22:56:28 +0100
Message-ID: <CAFLxGvxthR5zCQzYR4dtMa=4S2W03K-v8a0d9MTt4Ow=t+UL2w@mail.gmail.com>
Subject: Re: Corrupted files after suspend to disk
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Dave Jones <davej@redhat.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Jiri Kosina <jkosina@suse.cz>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        keithp@keithp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:49 PM, Dave Jones <davej@redhat.com> wrote:
>
> This looks like the i915 corruption problem mentioned in a few other threads.
>
> if you compare the hexdump of the good/bad files, you find that the corruption
> happens in 8x 4 byte writes of either 0x00000000 or 0x00aaaaaa.
>

This makes sense.
I'll have a look at the pattern next time!

-- 
Thanks,
//richard
