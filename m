Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0H1LOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:14:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63298 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0H1LOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:14:19 -0400
Message-ID: <4C78F07E.1040709@cn.fujitsu.com>
Date: Sat, 28 Aug 2010 19:18:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 0/5] KVM: MMU: some bugfix for mmu audit code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some bugfix patches for mmu audit code:

[PATCH 1/5] KVM: MMU: fix compile warning in audit code
[PATCH 2/5] KVM: MMU: check rmap for every spte
[PATCH 3/5] KVM: MMU: fix wrong not write protected sp report
[PATCH 4/5] KVM: MMU: rewrite audit_mappings_page() function
[PATCH 5/5] KVM: MMU: remove count_rmaps()
