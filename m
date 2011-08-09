Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1HIMEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:04:07 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:34261 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1HIMEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:04:05 -0400
Message-ID: <4E41222B.8060003@gmail.com>
Date: Tue, 09 Aug 2011 21:03:55 +0900
From: "J.Hwan Kim" <frog1120@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RSS mode performance in ixgbe (82599) driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone

I'm testing the RSS mode throughput of Intel ixgbe 82599 driver.
My server's specification is Xeon 3GHz (4cores) and PCIe speed is 
2.5Gx8lanes,
and DD2 memory is about 600~700MHz.

When I enable the RSS(receive side scaling) mode with 4 Rx queues,
the Rx performance is below than when I use a single queue.

I don't know how the cores operate, whether the cores run in sequence
or simultaneously at the same time.

I want to know the mechanism in general how the multi-cores run
and the reason why the performance of ixgbe driver in rss mode is below
non-rss mode.

Thanks in advance.

Best Regards,
J.Hwan Kim





