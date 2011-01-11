Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1AKIAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:00:36 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:47434 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1AKIAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:00:30 -0500
Date: Tue, 11 Jan 2011 03:00:26 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next <linux-next@vger.kernel.org>
Message-ID: <1197944404.42526.1294732826847.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <704975885.41077.1294719050536.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: bnx2 card cannot be detected (WAS Re: mmotm 2011-01-06-15-41
 uploaded)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This was introduced again by this big patch,
> linux-next.patch
> 
> GIT 47ec85165ad275a2ca62c4aca4bf029e9ffd6af0
> git+ssh://master.kernel.org/pub/scmm
> /linux/kernel/git/sfr/linux-next.git
Tested in the linux-next tree, and the problem went away with 2.6.37-next-20110111.

CAI Qian
