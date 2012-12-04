Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab2LDGRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 01:17:45 -0500
Received: from plane.gmane.org ([80.91.229.3]:57707 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab2LDGRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 01:17:44 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Woody Wu <narkewoody@gmail.com>
Subject: Why a host not ping-able?
Date: Tue, 4 Dec 2012 06:17:25 +0000 (UTC)
Message-ID: <slrnkbr59r.us1.narkewoody@zuhnb712.local.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 59.37.26.98
User-Agent: slrn/0.9.9p1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, list

I am not sure this has something with kernel.  But the system I just
generated cannot be reached from ping.  It can ping outside, but if I
ping it from outside, I just get "Destination Host Unreachable".

I think there is not firewall in between, and the two host in the test
are in the same ethernet sub network.  Is that possible the strange
behavior caused by somehow misconfigured kernel?

-- 
woody
I can't go back to yesterday - because I was a different person then.

