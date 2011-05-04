Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1EDRbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:31:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56549 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1EDRbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:31:02 -0400
Date: Wed, 4 May 2011 13:27:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ath5k regression associating with APs in 2.6.38
Message-ID: <20110504172716.GC18541@tuxdriver.com>
References: <20110504153819.GA4551@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504153819.GA4551@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 10:38:19AM -0500, Seth Forshee wrote:
> I've been investigating some reports of a regression in associating with
> APs with AR2413 in 2.6.38. Association repeatedly fails with some
> "direct probe to x timed out" messages (see syslog excerpt below),
> although it will generally associate eventually, after many tries.
> 
> Bisection identifies 8aec7af (ath5k: Support synth-only channel change
> for AR2413/AR5413) as offending commit. Prior to this commit there are
> no direct probe messages at all in the logs. I've also found that
> forcing fast to false at the top of ath5k_hw_reset() fixes the issue.
> I'm not sure what the connection is between this commit and the
> timeouts. Any suggestions?

Have you tried reverting that commit on top of 2.6.38?  Can you
recreate the issue with 2.6.39-rc6 (or later)?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
