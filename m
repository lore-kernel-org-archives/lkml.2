Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab0CXRkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:40:22 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:49981 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab0CXRkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:40:20 -0400
From: Frans Pop <elendil@planet.nl>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/09] net: remove trailing spaces in messages
Date: Wed, 24 Mar 2010 18:40:15 +0100
User-Agent: KMail/1.9.9
Cc: Per Liden <per.liden@ericsson.com>, Jon Maloy <jon.maloy@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>,
       Samuel Ortiz <samuel@sortiz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, e1000-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003241840.18701.elendil@planet.nl>
X-OriginalArrivalTime: 24 Mar 2010 17:40:19.0065 (UTC) FILETIME=[12386E90:01CACB79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second patchset to remove trailing spaces in kernel messages. 
Patches in this set cover networking code, excepting wireless which will be 
submitted in a separate set.

Patches have been rebased against current net-next.

Benefits are:
- general cleanup and consistency
- minor reduction in kernel size and user's log file size
- reduced annoyance for people writing logcheck rules

I have run the patches through checkpatch and included some fixes, but in 
most cases the files are so horrible in general that fixing the warnings 
purely for these changes doesn't make sense.

Shortstat:
 56 files changed, 236 insertions(+), 236 deletions(-)

Frans Pop (9):
      net: remove trailing space in messages
      net/tipc: remove trailing space in messages
      net/irda: remove trailing space in messages
      net/ps3_gelic: remove trailing space in messages
      net/smc91xx: remove trailing space in messages
      net/tokenring: remove trailing space in messages
      net/tulip: remove trailing space in messages
      net/intel: remove trailing space in messages
      net/various: remove trailing space in messages

Cheers,
FJP
