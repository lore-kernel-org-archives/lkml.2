Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3ADNxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:53:45 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44523 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3ADNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:53:42 -0500
Message-ID: <50E6DEDC.7040800@linux.vnet.ibm.com>
Date: Fri, 04 Jan 2013 21:53:32 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 0/5] KVM: x86: improve reexecute_instruction
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010413-5140-0000-0000-000002936FC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some changes from Gleb's review:
- poss the point of target_gfn_is_pt into FNAME(is_self_change_mapping)
  to let the return value be more clearer
- fold some changes of patch 5 into patch 4
- remove vcpu.arch.fault_addr

There are some test cases to trigger the bugs which are fixed in this patchset,
they can be found at:
http://marc.info/?l=kvm&m=135513072903953&w=2
http://marc.info/?l=kvm&m=135555502408253&w=2

