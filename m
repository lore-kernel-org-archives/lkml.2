Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1HEHnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:43:45 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:45327 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1HEHnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:43:42 -0400
X-ASG-Debug-ID: 1312530221-03d6a510a62582e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E3B9F2C.7080809@fusionio.com>
Date: Fri, 5 Aug 2011 09:43:40 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Moyer Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] cfq-iosched: Add documentation about idling [V2]
References: <20110802174006.GD6399@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] cfq-iosched: Add documentation about idling [V2]
In-Reply-To: <20110802174006.GD6399@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312530221
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70955
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-02 19:40, Vivek Goyal wrote:
> There are always questions about why CFQ is idling on various conditions.
> Recent ones is Christoph asking again why to idle on REQ_NOIDLE. His
> assertion is that XFS is relying more and more on workqueues and is
> concerned that CFQ idling on IO from every workqueue will impact
> XFS badly.
> 
> So he suggested that I add some more documentation about CFQ idling
> and that can provide more clarity on the topic and also gives an
> opprotunity to poke a hole in theory and lead to improvements.
> 
> So here is my attempt at that. Any comments are welcome.

Applied, thanks.

-- 
Jens Axboe

