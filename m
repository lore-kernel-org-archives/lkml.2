Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab0IWRWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:22:53 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:37983 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755645Ab0IWRWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:22:52 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ONsDyTUVM1m0P3BQsrN56_HNlyQvfeH8G43XT4ycydtIIU2
 Pahj7ZOA_.vRoPOnTs1BI39y2maEx32ITjgFvQa3JLMgntLOnaJeOB5ttLYZ
 cos7I8lLOddy0X1VE6U1j9RGgaEy1bL8R8XFU9_3Xi3cBBZy_tkmm40f0.yw
 mE3hyBXYfS_wL8qyMPTz9mzX.y7TRajp7UpiWICl69imJmkQq3skdZYrIjM8
 crJE8Qurok4463BSMaPTz99bO1rpi4NMJKvBpLw--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Sep 2010 11:54:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] HWPOISON, hugetlb: add free check to
 dequeue_hwpoison_huge_page()
In-Reply-To: <1283908781-13810-6-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1009231154500.32567@router.home>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283908781-13810-6-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>


