Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2FKI6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:58:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37715 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2FKI6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:58:49 -0400
Date: Mon, 11 Jun 2012 10:58:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        kiran.thirumalai@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/vsmp: Ignore IOAPIC IRQ affinity if
 possible
Message-ID: <20120611085843.GL31556@gmail.com>
References: <1338675095-27260-2-git-send-email-ido@wizery.com>
 <tip-3aabb53ce5849605cee731bbc32f37120b4c4ceb@git.kernel.org>
 <20120608085229.GA10638@gmail.com>
 <20120608154301.GA11242@NoteStation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608154301.GA11242@NoteStation>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> This seems to break when CONFIG_PARAVIRT is set but CONFIG_SMP 
> isn't. Since there's little point in optimizing IOAPIC routing 
> for UP kernels, how about the following fix?

Looks good to me, I'll give it some testing.

Thanks,

	Ingo
