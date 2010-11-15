Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0KOOE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:04:28 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:30977 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755738Ab0KOOE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:04:27 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 8TGnlsMVM1m9HPMLJJ3SJvblVI.U2j_MhweKY5J.OPeD4GF
 h0rdoS5Xn.AKT.zSrECpTwXRRzrCRhhuePLeNsIkDeE.nwuK04OF8brN0Oph
 kVAMn1TQ.QrYJyGJr72vg0PJLoYrOMIkZFzJ8UXp5DCm_qL9TPUtvvt_taaK
 V6CzH0l82xY8MePNzOHGtdWw2bpBCsYKR0NdWcyd1bmhp_jTtmpcp7Wt.v76
 _DMoPKKfmzqs-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 15 Nov 2010 08:04:23 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] set_pgdat_percpu_threshold() don't use
 for_each_online_cpu
In-Reply-To: <20101115102617.GK27362@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1011150802470.19175@router.home>
References: <1288169256-7174-2-git-send-email-mel@csn.ul.ie> <20101028100920.5d4ce413.kamezawa.hiroyu@jp.fujitsu.com> <20101114163727.BEE0.A69D9226@jp.fujitsu.com> <20101115102617.GK27362@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Mel Gorman wrote:

> With recent per-cpu allocator changes, are we guaranteed that the per-cpu
> structures exist and are valid?

We always guarantee that all per cpu areas for all possible cpus exist.
That has always been the case. There was a discussion about changing
that though. Could be difficult given the need for additional locking.


