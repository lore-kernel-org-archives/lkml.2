Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0CZKDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 06:03:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0CZKDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:03:20 -0400
Subject: set_cpus_allowed_ptr
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
       Oleg Nesterov <oleg@redhat.com>, Julia Lawall <julia@diku.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 11:03:16 +0100
Message-ID: <1269597796.12097.133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Would it make sense to clean up the set_cpus_allowed() vs
set_cpus_allowed_ptr() mess using the semantic patch tool?

I guess it would be three patches:
 1) converting the current remaining set_cpus_allowed() users into
    set_cpus_allowed_ptr().
 2) remove set_cpus_allowed().
 3) rename set_cpus_allowed_ptr() to set_cpus_allowed()



