Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2KQFJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:09:59 -0500
Received: from plane.gmane.org ([80.91.229.3]:35586 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab2KQFJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:09:58 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Woody Wu <narkewoody@gmail.com>
Subject: When is save to print console messages?
Date: Sat, 17 Nov 2012 04:48:20 +0000 (UTC)
Message-ID: <slrnkae5n6.354.narkewoody@zuhnb712.local.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 119.120.107.227
User-Agent: slrn/0.9.9p1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to use print some trace messages to the console in the kernel
setup/init stages. But I don't know what is the earliest time when safe
to do that.  Sould be somewhere after decompress_kernel() invocation?

And, when should I use putstr() and when to use printk()? Thans.

-- 
-woody
I can't go back to yesterday - because I was a different person then.

