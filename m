Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab0IGCEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 22:04:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56090 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab0IGCEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 22:04:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 13/14] mm: mempolicy: Check return code of check_range
Cc: kosaki.motohiro@jp.fujitsu.com, Kulikov Vasiliy <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1009062058270.1485@router.home>
References: <20100906093610.C8B5.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009062058270.1485@router.home>
Message-Id: <20100907110254.C8F2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  7 Sep 2010 11:04:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 6 Sep 2010, KOSAKI Motohiro wrote:
> 
> > I think both case is not happen in real. Am I overlooking anything?
> 
> Its good to check the return code regardless. There is a lot of tinkering
> going on with that code.

OK. so, I'm convinced this is not -stable material.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


