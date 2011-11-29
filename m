Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1K2Kj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:39:57 -0500
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:57985 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab1K2Kj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:39:56 -0500
X-Greylist: delayed 3169 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Nov 2011 05:39:56 EST
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Jason Baron <jbaron@redhat.com>
Subject: Enabling dynamic debug at module load
Date: Tue, 29 Nov 2011 09:47:03 +0000
User-Agent: KMail/1.13.7 (Linux/3.1.0-1.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111290947.03046.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jason,

What happened to the proposed patch to enable dynamic debug lines at module 
load time?

After hitting this problem when trying to figure out why w83627ehf does not 
load I found that apparently there is no way to enable pr_debug's called from 
its module_init and googling discovered this thread: 
https://lkml.org/lkml/2010/5/26/192

Thanks,

Tvrtko
