Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0FOIuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:50:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0FOIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:50:10 -0400
Date: Tue, 15 Jun 2010 04:50:07 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alan <alan@clueserver.org>
Cc: linux-kernel@vger.kernel.org, dcbw@redhat.com
Subject: Re: Possible NetworkManager problem with 2.6.35-rc3
Message-ID: <20100615085007.GN20317@bombadil.infradead.org>
References: <54979.10.6.6.23.1276550815.squirrel@10.6.6.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54979.10.6.6.23.1276550815.squirrel@10.6.6.2>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 02:26:55PM -0700, Alan wrote:
> In order to get my sata controller to work I built a current kernel using
> the config file from my Fedora 13 system.
> 
> Everything works except for networking.
> 
> It uses the forcedeth driver, but network manager does not want to see the
> card whatsoever.
> 
<snip>
> Jun 14 13:43:43 zowie NetworkManager[894]: <warn> /sys/class/net/eth0:
> couldn't determine device driver; ignoring...
> Jun 14 13:43:43 zowie NetworkManager[894]: <warn> /sys/class/net/eth1:
> couldn't determine device driver; ignoring...

Even if there is a sysfs bug in 2.6.35-rc3, it looks pretty braindead
that network-manager falls over for this.

Dan, any ideas?

--Kyle
