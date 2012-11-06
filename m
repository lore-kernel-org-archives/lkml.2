Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2KFFdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:33:40 -0500
Received: from intranet.asianux.com ([58.214.24.6]:48623 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2KFFdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:33:39 -0500
X-Spam-Score: -100.8
Message-ID: <5098A16F.4010807@asianux.com>
Date: Tue, 06 Nov 2012 13:34:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Consult] for many minor and trivial patches about "* change %8s
 to %s *"
References: <50988B04.1090904@asianux.com>
In-Reply-To: <50988B04.1090904@asianux.com>
X-Forwarded-Message-Id: <50988B04.1090904@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All:


1) Status:

   A) I have many "* change %8s to %s *" patches (minor and trivial
patches).

   B) for net subsystem, have 3 (have sent to relative members);

   C) for another:

      i)  arch/x86/kernel/process_64.c:120,
          pr_warn("WARNING: dead process %8s still has LDT? <%p/%d>\n",
          dead_task->comm is 16 (TASK_COMM_LEN)

      ii) arch/blackfin/kernel/irqchip.c:52:
          seq_printf(p, " %8s", irq_desc_get_chip(desc)->name);
          name is not solid length, such as "tilegx_msi" in
arch/tile/kernel/pci_gx.c

2) Next:

   A) It seems, it is only a start (If I am 'lucky' enough, maybe can
find more).

   B) for these minor and trivial patches for various subsystems.

   C) have 3 sending ways:

      i)  let each relative subsystem only has one patch which include
all relative trivial modifications.

      ii) or gather them into one patch and send to
linux-kernel@vger.kernel.org.

      iii) or each minor and trivial patch is an individual.


3) Suggestion:

   A) I prefer the first choice (let each subsystem only has one patch)

   B) I will do it according to the first choice, until get another
suggestions.


thanks.

-- 
Chen Gang

Asianux Corporation


