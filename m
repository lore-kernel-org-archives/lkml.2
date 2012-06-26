Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2FZX4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2FZX4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:56:39 -0400
Date: Tue, 26 Jun 2012 19:56:10 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: chmod +x scripts/gfp-translate
Message-ID: <20120626235610.GA10325@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script lacks an executable bit.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/scripts/gfp-translate b/scripts/gfp-translate
old mode 100644
new mode 100755
