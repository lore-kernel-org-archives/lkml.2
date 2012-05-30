Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab2E3T1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:27:37 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:40641 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750903Ab2E3T1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:27:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: k6OrO90VM1ngYitKkKQXdtVC6hg0I5WR9AAd3pWnbQPXnrR
 gBjQBBhreuKWwIAOmBAPIA4G8Gxb6QgDdws1xqQ1QlAG_s7aUcJar2k8cE0I
 cRC4MDmgCJB5mUS2JRzkF.ogJziodcJaTPKyyQkd7X29qy18TQyobnhG1xf1
 NY3bxtlwWipyU0R6jDcSfoED3eu47McvMtLmydDjV2Gg2CzyJgnRnh2ZCOP_
 ZsFjzzzCbH8zfNCqdrtan8QFPz_8XvudGiKaVwLAn_DWffampkVca182Q4aN
 K9Uec5buLB4dZiX339rTxaminC733jxjR6ZN7zRiLt3uPD7RxBwbkzf.S70R
 2TtB4au.qCQUkd45BMQfA1QVH_dIqM7HGMEoivOu2TN98aT11Qh_6LRSqKeU
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 14:27:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: kosaki.motohiro@gmail.com
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        hughd@google.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        andi@firstfloor.org
Subject: Re: [PATCH 6/6] MAINTAINERS: Added MEMPOLICY entry
In-Reply-To: <1338368529-21784-7-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.00.1205301425510.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <1338368529-21784-7-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glad that someone is willing to take this on. Shared memory policies are
an ugly thing.

Adding Andi. He needs to be cced on future postings of this patchset.

Acked-by: Christoph Lameter <cl@linux.com>
