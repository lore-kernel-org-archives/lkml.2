Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab1JCXUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:20:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:46845 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab1JCXUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:20:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: John Musbach <johnmusbach1@gmail.com>
Subject: Handling of multiple DHCP OFFERs
Date: Mon, 3 Oct 2011 23:18:06 +0000 (UTC)
Message-ID: <loom.20111004T011704-753@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 24.93.19.169 (Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.186 Safari/535.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I am configuring a network that'll have multiple DHCP servers
and I was wondering how Linux handles receiving multiple DHCP OFFERs?
More specifically, how does it choose which one to prefer and how long
will it wait for a answer from a preferred server if the other server
answers first? Thanks.

