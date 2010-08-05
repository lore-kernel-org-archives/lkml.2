Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab0HEFcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:32:45 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44282 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0HEFco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:32:44 -0400
Message-ID: <4C5A4CF4.4070203@linux.vnet.ibm.com>
Date: Thu, 05 Aug 2010 11:02:36 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        linuxppc-dev@ozlabs.org, netdev <netdev@vger.kernel.org>,
        jeffrey.t.kirsher@intel.com
Subject: [linux-next] build failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yestersday's linux-next(2.6.35_next_20100802) build fails with the following error on both system p and x.


   drivers/net/ixgbe/ixgbe_main.c: In function 'ixgbe_select_queue':
   drivers/net/ixgbe/ixgbe_main.c:6159: error: 'struct ixgbe_fcoe' has no member named 'up'
   drivers/net/ixgbe/ixgbe_main.c: In function 'ixgbe_xmit_frame':
   drivers/net/ixgbe/ixgbe_main.c:6221: error: 'struct ixgbe_fcoe' has no member named 'up'
   make[3]: *** [drivers/net/ixgbe/ixgbe_main.o] Error 1
   make[2]: *** [drivers/net/ixgbe] Error 2
   make[2]: *** Waiting for unfinished jobs....
   make[1]: *** [drivers/net] Error 2
   make: *** [drivers] Error 2

Thanks
Divya



