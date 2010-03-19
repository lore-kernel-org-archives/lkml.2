Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0CSSP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:15:29 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:9639 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab0CSSP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:15:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAItbo0tbtPaL/2dsb2JhbACbPHS6TYR6BA
Message-ID: <4BA3BE9B.5050201@computer.org>
Date: Fri, 19 Mar 2010 19:12:43 +0100
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Reading entropy_avail file appears to consume entropy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using the 2.6.31 kernel that comes with Ubuntu 9.10.

If I

   # watch cat /proc/sys/kernel/random/entropy_avail

then the size of the entropy pool falls rapidly (by more than 200 bytes per 2s interval). It settles down around 160 bytes.

The machines on which I've done the above experiment are otherwise idle. They are also dramatically different from one another: one is a laptop, the other is an embedded device (a Soekris net5501).

Is this supposed to happen?

Thanks, Jan
