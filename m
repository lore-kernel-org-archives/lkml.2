Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0LAB3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:29:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33656 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0LAB3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:29:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Dec 2010 10:23:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] Refactor zone_reclaim
Message-Id: <20101201102329.89b96c54.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101130101520.17475.79978.stgit@localhost6.localdomain6>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
	<20101130101520.17475.79978.stgit@localhost6.localdomain6>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 15:45:55 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Refactor zone_reclaim, move reusable functionality outside
> of zone_reclaim. Make zone_reclaim_unmapped_pages modular
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Why is this min_mapped_pages based on zone (IOW, per-zone) ?


Thanks,
-Kame

