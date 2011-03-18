Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab1CRVlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:41:39 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:35826 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932524Ab1CRVle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:41:34 -0400
Message-ID: <4D83D188.3000909@tlinx.org>
Date: Fri, 18 Mar 2011 14:41:28 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: minor doc correction: Documentation/iostats.txt: bit-size reference
X-Stationery: 0.5.1
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Documentation/iostats.txt describes fields in /proc/diskstats as
32-bit unsigned values that can wrap.

On a 64-bit system, it appears they are 64-bit unsigned values.

Should 'iostats.txt' describe fields as "unsigned, native-word-sized 
values" or is my 64-bit system not behaving according to "spec"? ;-)


Linda


