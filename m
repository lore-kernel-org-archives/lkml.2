Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1JTJXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:23:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48326 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1JTJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:23:30 -0400
Message-ID: <4E9FE8C6.10402@gmail.com>
Date: Thu, 20 Oct 2011 17:24:22 +0800
From: snakky.zhang@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Why BOOT_PRINTK_DELAY "may adversely affect SMP systems"?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,

I noticed there is an kernel option called BOOT_PRINTK_DELAY and some
warning messages in the Kconfig file as below:

NOTE:  Using this option may adversely affect SMP systems. I.e.,
processors other than the first one may not boot up. BOOT_PRINTK_DELAY
also may cause DETECT_SOFTLOCKUP to detect what it believes to be lockup
conditions.

As my understanding, this do nothing but just let the very CPU loop for
a while and shouldn't cause any affect on the boot process. So I can
hardly understand WHY it may cause "processors other than the first one
may not boot up"? If this issue can be avoid/fixed?

Thanks a lot!
Snakky

