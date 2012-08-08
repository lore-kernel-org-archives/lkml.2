Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab2HHEFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 00:05:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7744 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2HHEFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 00:05:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 07 Aug 2012 21:05:37 -0700
Message-ID: <5021E3D8.3010503@nvidia.com>
Date: Wed, 8 Aug 2012 09:28:17 +0530
From: Venu Byravarasu <vbyravarasu@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <rdunlap@xenotime.net>, <lars@metafoo.de>,
        <grant.likely@secretlab.ca>, <joe@perches.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@nvidia.com>
Subject: What is the significance of coherent_dma_mask?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some of the USB drivers are setting coherent_dma_mask & many others are 
not doing it.
 From the description present in the comment beside this field in 
device.h, I could not understand its real significance.

Can some one plz let me know its real need and use case where it is 
mandatory to use it?

Thanks,
Venu


