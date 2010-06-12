Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0FLK2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 06:28:12 -0400
Received: from smtp-out-223.synserver.de ([212.40.180.223]:1039 "HELO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752320Ab0FLK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 06:28:07 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 22066
Date: Sat, 12 Jun 2010 12:28:02 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: john.r.fastabend@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Subject: mpd client timeouts (bisected) 2.6.35-rc3
Message-ID: <20100612102802.GA1782@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837:
»net: deliver skbs on inactive slaves to exact matches«

causes large timeouts when mpd clients try to connect to a locally
running mpd (music player demon) on my machine. This makes it 
impossible to control mpd.

I bisected this down to the commit mentioned above.
Reverting the commit from 2.6.35-rc3 also solves the problem.

-- 
Markus
