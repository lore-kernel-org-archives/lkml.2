Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1HYHUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:20:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39212 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1HYHUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:20:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Aug 2011 16:13:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2011-08-24-14-08 uploaded
Message-Id: <20110825161307.7c921e46.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
References: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 14:09:05 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-08-24-14-08 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 3.1-rc3:
> (patches marked "*" will be included in linux-next)
> 

just reporting.

A compile error from linux-next.patch.

drivers/built-in.o: In function `dwc3_testmode_open':
/home/kamezawa/Kernel/mmotm-Aug24/drivers/usb/dwc3/debugfs.c:481: undefined reference to `dwc3_send_gadget_ep_cmd'
/home/kamezawa/Kernel/mmotm-Aug24/drivers/usb/dwc3/debugfs.c:482: undefined reference to `dwc3_send_gadget_ep_cmd'
make: *** [.tmp_vmlinux1] Error 

Thanks,
-Kame

