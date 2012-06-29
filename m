Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2F2Mu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:50:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35477 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab2F2Mu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:50:57 -0400
Date: Fri, 29 Jun 2012 14:50:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, joe@perches.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86/early_printk: Replace obsolete
 simple_strtoul() usage with kstrtoint()
Message-ID: <20120629125052.GC32637@gmail.com>
References: <1338424803.3569.5.camel@lorien2>
 <tip-fbd24153c48b8425b09c161a020483cd77da870e@git.kernel.org>
 <20120622142456.GA24850@gmail.com>
 <1340644628.6882.3.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340644628.6882.3.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shuah Khan <shuahkhan@gmail.com> wrote:

> > I'm dropping this patch.
> 
> No problem. I missed return value check in one path. Will fix 
> it and send the fixed patch. I probably will pool this change 
> with other simple_strtoul() cleanup related changes I am 
> working on.

Yep, that will probably make it easier to review in a batch, 
looking for side effects and such.

Thanks,

	Ingo
