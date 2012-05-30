Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab2E3SuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:50:09 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:42381 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753221Ab2E3SuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:50:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cp4WlZQVM1kWzb5.ImH3s1p9.yfFbeYWfFpUIDm5t9AlhA_
 UQ.pbWjuQNE94zDPMmmyYXMJ1cnMDlO0bYsFLaz7M1DEcWZoZKpgaSmdfujk
 ICeHYz_3wLSTDdX5AP4kTtmUH6A8nxaZq1CYU5k_Rrigqtku_R2GdUvJFwaG
 H7tgWeQNV7c_8leeFY60TCsXWHsDgRhSNVVYCz6xjz7.JMaao1jdOtYMRh1R
 Jj8CzcHPLa7.E9oqExbwmE4ZFPkA7XSI_MLIhsn_maBNdMtcpCcTgykJ_Xfp
 b7nIruuVo.q9BnKmW2L_KHc0lrfzBkdh_r5a_8tWHhaTLQLHHBdU5A.6wCD4
 TR1nbL3cwfB.eH6YDRjJdWxsFUQQNOCs1Pkee3jO4q_vSL2hVXC.KtyQiKSh
 e
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 13:50:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org, hughd@google.com,
        sivanich@sgi.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
In-Reply-To: <20120530184638.GU27374@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1205301349230.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Andi Kleen wrote:

> I always regretted that cpusets were no done with custom node lists.
> That would have been much cleaner and also likely faster than what we have.

Could shared memory policies ignore cpuset constraints?
