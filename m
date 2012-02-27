Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2B0KFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:05:08 -0500
Received: from plane.gmane.org ([80.91.229.3]:51470 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab2B0KFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:05:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthew Turnbull <matthew.turnbull.cs@gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Date: Mon, 27 Feb 2012 10:00:22 +0000 (UTC)
Message-ID: <loom.20120227T103916-518@post.gmane.org>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 174.63.74.147 (Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120226 Firefox/13.0a1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norbert Preining <preining <at> logic.at> writes:

> long time ago we had a long discussion about iwlagn regressions in 3.1.0
> Up to 3.2 I still have regular problems on the university network
> with stuck iwl driver not even realizing that nothing goes out or in.
> 
> Today I switched to 3.3-rc1 to see it is getting even worse, now on my
> home network I get stuck queue and no connection:

I've had a similar problem. Starting with 3.1.0, iwlagn would sporadically
'drop' connections, despite sill appearing to be connected (nothing obvious in
dmesg). Cycling rfkill would bring it back for a while.

I recently came across another topic, with the same issue, and this patch was
recommended:

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git;
a=commitdiff;h=5dcbf480473f6c3f06ad2426b7517038a2a18911

I applied that on top of 3.2.6 and *knock on wood* I haven't seen the issue
reoccur.

