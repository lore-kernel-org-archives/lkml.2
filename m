Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0DUMTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:19:43 -0400
Received: from lazybastard.de ([212.112.238.170]:59805 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0DUMTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:19:42 -0400
Date: Wed, 21 Apr 2010 14:19:32 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Please pull logfs tree for fixes
Message-ID: <20100421121932.GA18441@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another set of fixes.  Two of them are security relevant.  But given
that an attacker needs mount access and few people have logfs compiled
in, that's unlikely to be a huge issue.

 gc.c        |    8 ++++++
 journal.c   |   29 ++++++++++++++---------
 logfs.h     |   15 ++++++++++--
 readwrite.c |   75 +++++++++++++++++++++++++++++++++---------------------------
 segment.c   |    8 ------
 super.c     |   11 +++++++-
 6 files changed, 91 insertions(+), 55 deletions(-)

Jörn

-- 
More computing sins are committed in the name of efficiency (without
necessarily achieving it) than for any other single reason - including
blind stupidity.
-- W. A. Wulf
