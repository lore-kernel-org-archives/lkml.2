Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2GXOGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:06:55 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47666 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2GXOGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:06:54 -0400
Date: Tue, 24 Jul 2012 16:06:45 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: joe shmoe <joeshmoeypeter@yahoo.com>
Cc: Daniel Kiper <dkiper@net-space.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        daniel.kiper@oracle.com
Subject: Re: kdump/kexec vmcore size doubles each time
Message-ID: <20120724140645.GA17687@router-fw-old.local.net-space.pl>
References: <1342735724.60460.YahooMailNeo@web160604.mail.bf1.yahoo.com> <20120720093648.GA3909@router-fw-old.local.net-space.pl> <1343087299.65126.YahooMailNeo@web160606.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343087299.65126.YahooMailNeo@web160606.mail.bf1.yahoo.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 04:48:19PM -0700, joe shmoe wrote:
> Hi,
> Thank you for the reply.

You are welcome.

> I ended up opting for writing to filesystem rather than
> raw_device and this seems to have helped me sidestep the
> problem for now.

Good move.

> Unfortunately, I can't quite make a jump to later sources.
>
> I do have another question, I see KDUMP_KEEP_OLD_DUMPS mentioned
> to automatically clean up prior dumps (for ex: http://dedoimedo.com/computers/kdump.html
> and other SUSE docs).
> However, I cannot find any logic in sources to do this (and sure
> enough I don't see older cores in my /var/crash/ path clean up
> as new cores are dumped).
>
> Could someone please comment if:
> (i) KDUMP_KEEP_OLD_DUMPS is unsupported or not. If it IS supported,
> could someone please help with the relevant source code so I could
> debug why it isn't working? Yes, I did download kexec-tools git but
> cannot find anything relevant.
>
> (ii) If there is NO explicit source code to achieve this -- then
> do folks achieve such a cleanup through KDUMP_PRE and KDUMP_POST scripts?
> If yes, is there a standard-ish script out there to achieve this?

Sorry but I could not help because I do not use SUSE.
But maybe guys from SUSE could point out something.

Daniel
