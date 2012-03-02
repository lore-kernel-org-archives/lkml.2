Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab2CBPZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:25:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51409 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab2CBPZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:25:20 -0500
Date: Fri, 2 Mar 2012 16:25:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, asit.k.mallick@intel.com
Subject: Re: change last level cache alignment on x86?
Message-ID: <20120302152506.GA14487@elte.hu>
References: <1330590816.21053.1336.camel@debian>
 <1330673425.21053.1503.camel@debian>
 <20120302081208.GA24504@elte.hu>
 <4F50DC42.3090300@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F50DC42.3090300@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> So, with defconfig on x86_64, I saw much changes in System.map:
> 	before patched			after patched
>   ...
>   000000000000b000 d tlb_vector_|  000000000000b000 d tlb_vector
>   000000000000b080 d cpu_loops_p|  000000000000b040 d cpu_loops_
>   ...

Ok, mind sending a patch, changelogged, with a SOB?

Thanks,

	Ingo
