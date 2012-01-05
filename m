Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2AEPBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:01:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab2AEPBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:01:04 -0500
Date: Thu, 5 Jan 2012 16:00:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: iwl3945 didn't survive after s2ram failure
Message-ID: <20120105150040.GE2222@redhat.com>
References: <20111227105340.GD5344@tiehlicka.suse.cz>
 <20120103103457.GA3391@redhat.com>
 <20120103130306.GA3891@tiehlicka.suse.cz>
 <20120105110744.GA2222@redhat.com>
 <20120105141913.GA3937@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105141913.GA3937@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:19:13PM +0100, Michal Hocko wrote:
> 
> OK, so I have tried to boot with pcie_aspm=off and the wireless
> resurrect. The I found out that I booted into 3.2 rather than 3.2-rc6 so
> I retested with the original kernel and guess what, yes it reported the
> same problem as before (with or without parameter). 
> So I have tried to retest with few kernels (3.2.0-rc5,
> 3.2.0-rc6-00005-ga36bfdd, 3.2.0-rc7-00083-g115e8e7 and 3.2.0) that I
> still had on my machine and 3.2.0-rc6-00005-ga36bfdd seems to be the
> only affected one.
> There doesn't seem to be any obvious difference wrt. the driver in the
> logs (attached).
> 
> Looking in the history it seems that 497f16f2 [pci: Fix hotplug of
> Express Module with pci bridges] might be related.

>From the changelog of that commit: "I noticed that the bridges get
assigned but do not get enabled", that looks like the problem we had
seen.

Anyway there is noting to do here, we have bug in 3.2-rc6 fixed in
3.2-rc7.

Thanks
Stanislaw
