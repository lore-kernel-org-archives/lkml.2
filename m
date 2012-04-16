Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2DPMUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:20:34 -0400
Received: from vt220.org ([109.74.202.194]:35364 "EHLO vt220.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab2DPMU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:20:29 -0400
Date: Mon, 16 Apr 2012 13:20:28 +0100
From: Steven Young <sdyoung@vt220.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] arcnet: rimi: Fix device name in debug output
Message-ID: <20120416122028.GA23830@vt220.org>
References: <20120415153220.GA11631@vt220.org>
 <alpine.LNX.2.00.1204161335420.16373@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204161335420.16373@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 02:02:48PM +0200, Jiri Kosina wrote:
> I propose the minimalistic fix instead ... it'd be better to just drop the 
> BUGMSG() thing altogether and convert it to dev_printk(), but that'd be 
> larger revamp of the driver, and such effort is questionable for something 
> like Arcnet :)

  You're right, I'm not really interested in spending any amount of time on
ARCnet.  It's just something I noticed when I was booting a poorly-configured
kernel and thought I'd try a drive-by fix. :)

  Thanks for your time,
  Steve.
