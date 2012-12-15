Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab2LOG5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:57:50 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49434 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2LOG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:57:49 -0500
Message-ID: <50CC1F62.4050701@linux.vnet.ibm.com>
Date: Sat, 15 Dec 2012 14:57:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 0/5] KVM: x86: improve reexecute_instruction
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121506-2000-0000-0000-00000A460E14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:
- do not change pte access for mmio access
- a new bug is exposed that Dirty bit is not tracked if CR0.WP = 0
- cache something on page fault path and use them to detect unhandleable
  instruction, suggested by Marcelo

I will add the two testcase for unhandleable instruction after figure
out a way to notify the unemulationable error to guest

