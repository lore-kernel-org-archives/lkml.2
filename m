Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0J0UOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:14:01 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:29389 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751369Ab0J0UN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:13:59 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: rXJDTREVM1nHe.G_E_d2fYZabGMaFC6uZbmNMT1mhdgyxUc
 Nqf7aZK_gZt7E_4FLPTboJvWfRROsfXtwAExh9L1kBsu9yP1lIEiPjVzNpFn
 YH3S45Y_ywZmd9W4Tr1Z6VyOws8NWOm6EK.xsVVRiWhzX312nJ4pFc8NMrVO
 W7ICTdvzSO.L40Y99uScNP2LLCzFaN8BWCM0bPi8L27.JIwSPe0a50lRKghk
 Ql96Q9whT0Mp5Lmhitq.ZkdO9.8190LNJNDwaAyBXRB1e5LBmz6OdBIWUCpn
 GlQKLcMWCOTyNHw--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 27 Oct 2010 15:13:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] mm: vmstat: Use a single setter function and callback
 for adjusting percpu thresholds
In-Reply-To: <1288169256-7174-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1010271513380.6255@router.home>
References: <1288169256-7174-1-git-send-email-mel@csn.ul.ie> <1288169256-7174-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>


