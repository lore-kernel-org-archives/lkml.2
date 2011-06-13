Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1FMVhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:37:41 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:33916 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906Ab1FMVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:37:39 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jun 2011 17:37:39 EDT
Date: Mon, 13 Jun 2011 21:31:59 +0000 (UTC)
From: johnlinn@comcast.net
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <315025466.1505794.1308000719987.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <1347566644.1505253.1308000163643.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
Subject: DMA setup for ARM platform with hole low in memory
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to decide the best way to setup this ARM platform DMA to deal with the fact that the lowest 512K of memory can not be DMAed into.  The rest of memory space is fine.

>From my digging and prototyping it seems like a DMA zone will do the job, but maybe there's an easier way. The DMA mask doesn't seem to really help with this hole in memory and would still need to be 0xFFFFFFFF it appears.

Am I missing the easier way?

Thanks,
John
