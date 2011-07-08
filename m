Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1GHOuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:50:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1GHOuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:50:03 -0400
Date: Fri, 8 Jul 2011 07:43:50 -0700
From: Greg KH <gregkh@suse.de>
To: Sachin Sanap <ssanap@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Zhangfei Gao <zgao6@marvell.com>, Philip Rakity <prakity@marvell.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [047/107] pxa168_eth: fix race in transmit path.
Message-ID: <20110708144350.GB22691@suse.de>
References: <20110708001657.257533921@clark.kroah.org>
 <EC64E4604C8024438259B683BB2514E1085C4A9142@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EC64E4604C8024438259B683BB2514E1085C4A9142@SC-VEXCH1.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 11:20:03PM -0700, Sachin Sanap wrote:
> ACK.

Now added, thanks.
