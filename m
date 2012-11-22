Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2KVXrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:47:06 -0500
Received: from plane.gmane.org ([80.91.229.3]:40283 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2KVXrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 18:47:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Woody Wu <narkewoody@gmail.com>
Subject: Can Linux recoginize vivi partition?
Date: Thu, 22 Nov 2012 00:22:40 +0000 (UTC)
Message-ID: <slrnkaqs0u.2jk.narkewoody@zuhnb712.local.com>
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

Does MTD recognize vivi partition and can parse its partition table? It
seems that only RedBoot partion is supported for the physmap device, is
that true? Now I have vivi partions on a memory mapped NOR flash and want
to load a root image from that. What should I do?

-- 
woody
I can't go back to yesterday - because I was a different person then.

