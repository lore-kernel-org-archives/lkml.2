Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab0I1JT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:19:26 -0400
Received: from suva.vyatta.com ([76.74.103.44]:45889 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab0I1JTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:19:25 -0400
X-Greylist: delayed 1947 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 05:19:25 EDT
Message-Id: <20100928084400.997539242@vyatta.com>
User-Agent: quilt/0.48-1
Date: Tue, 28 Sep 2010 17:44:01 +0900
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] namespace.pl fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried looking for code that should be static using the
namespace.pl script, but it appears to have been unused and
broken for a while.

