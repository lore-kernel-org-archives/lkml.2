Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2JQKfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:35:52 -0400
Received: from smtp.getmail.no ([84.208.15.66]:45162 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab2JQKfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:35:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Realtime threads for less jitter (w/ X)?
Date: Wed, 17 Oct 2012 12:35:45 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wmbjpvqe6426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I just learned that X was singlethreaded. Setting it to realtime fifo,  
pri 98, fixes slowing down doom 3 (which I use for testing), when moving  
other windows, as that is probably due to waiting for X.

Now I wonder should RCU priority boost be at 99, or below X? Probably  
above right?

And are there other threads, that X is again waiting for, that should be  
above X?

Peace Be With You.
