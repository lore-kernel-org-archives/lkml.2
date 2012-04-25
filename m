Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875Ab2DYEAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:00:51 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49021 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2DYEAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:00:50 -0400
Message-ID: <4F9776D2.7020506@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2012 12:00:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 00/10] KVM: MMU: fast page fault
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042504-2000-0000-0000-0000073D1489
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlong:
- split the meaning of SPTE_ALLOW_WRITE and rename it to SPTE_MMU_WRITEABLE

- introduce a middle patch that update spte under the protection of mmu-lock
  for better review.

