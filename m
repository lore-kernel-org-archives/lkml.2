Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1GKTSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:18:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60363 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab1GKTS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:18:29 -0400
Message-ID: <4E1B4CF8.605@cn.fujitsu.com>
Date: Tue, 12 Jul 2011 03:20:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 00/18] KVM: optimize for MMIO handled
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-12 03:17:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-12 03:17:44,
	Serialize complete at 2011-07-12 03:17:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in this new version:
- fix the logic of dirty bit in [PATCH 04/19] KVM: MMU: cache
  mmio info on page fault path
- rename is_mmio_pfn() to is_noslot_pfn() to avoid the conflicts
  with kvm_is_mmio_pfn
- remove [PATCH 14/19] KVM: MMU: clean up spte updating and clearing
- completely check the last spte for mmio page fault suggested
  by Marcelo Tosatti
