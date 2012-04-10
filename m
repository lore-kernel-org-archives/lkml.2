Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2DJQma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:42:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56910 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2DJQm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:42:29 -0400
Message-ID: <4F8462DE.4030004@ti.com>
Date: Tue, 10 Apr 2012 22:12:06 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] arm: davinci: use for_each_set_bit_from
References: <1333442836-9947-1-git-send-email-akinobu.mita@gmail.com> <1333442836-9947-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1333442836-9947-3-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

On 4/3/2012 2:17 PM, Akinobu Mita wrote:
> Use for_each_set_bit_from to iterate over all the set bit in a memory
> region.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org

Looks good to me. If you are planning to send this upstream outside of
davinci tree, please add my:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Else, let me know and I will be happy to queue it.

Thanks,
Sekhar
