Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0GXIn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:43:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47423 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0GXIn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:43:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@kernel.dk>
Subject: Re: VFS scalability git tree
Cc: kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20100722190100.GA22269@amd>
References: <20100722190100.GA22269@amd>
Message-Id: <20100724174038.3C96.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat, 24 Jul 2010 17:43:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At this point, I would be very interested in reviewing, correctness
> testing on different configurations, and of course benchmarking.

I haven't review this series so long time. but I've found one misterious
shrink_slab() usage. can you please see my patch? (I will send it as
another mail)


