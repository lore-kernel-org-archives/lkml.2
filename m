Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0IVUlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:41:52 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:26569 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752420Ab0IVUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:41:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: B09JL8sVM1nm5.cSNGZpeyU5BND1AJ3XBPQTpQ7bzYsHYtI
 ttHFbGY2xxWyoEhd4VxmuVV6sblUjgC9y_wWQ8jwfmaZmtJhWXvQab4dKAIj
 YvRSerepnT5zhdlxA5Fq9c0FKk50q_6CY0KOxreLMRqeVFza17osof26Xnl8
 QKaLAA2TIAkJ.iiy5eYTO.ybvTTHPOiTdd4TLh6kv5i7dVY6qK6wpequuD61
 QG424YJW.3xIwcl4Nij7whtoHvC5DBs6gGJa4ig--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 22 Sep 2010 15:41:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] hugetlb: fix metadata corruption in
 hugetlb_fault()
In-Reply-To: <20100920104723.GG1998@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1009221541350.32661@router.home>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283908781-13810-2-git-send-email-n-horiguchi@ah.jp.nec.com> <20100920104723.GG1998@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>


