Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2KFObO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:31:14 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:53884 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795Ab2KFObN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:31:13 -0500
Date: Tue, 6 Nov 2012 06:31:09 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, George Zhang <georgezhang@vmware.com>
Message-ID: <1891962703.13755196.1352212269838.JavaMail.root@vmware.com>
In-Reply-To: <20121106101013.09806f81@s6510.linuxnetplumber.net>
Subject: Re: [Pv-drivers] [PATCH 1/6] VSOCK: vsock protocol implementation.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC22 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> You did some scrubbing of the macro's to support multiple kernel
> versions, but there are still some leftovers.
> This code seems to have a lot of "this added in version xxx"
> type comments. These are probably not a good idea to include
> in the mainline kernel code.

Thanks so much for taking a look.  Sorry about that, we'll remove
all such occurrences and send out a new series of patches in a bit.

Thanks!
- Andy
