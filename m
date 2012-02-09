Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2BIHad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:30:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38545 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab2BIHac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:30:32 -0500
Date: Thu, 9 Feb 2012 08:30:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data on
 a VM
Message-ID: <20120209073024.GA18010@elte.hu>
References: <4F32A907.6030505@gmail.com>
 <20120208174434.GI22598@amd.com>
 <4F32B680.3090502@gmail.com>
 <20120208175709.GK22598@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208175709.GK22598@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> > which makes sense. It forces 
> > perf_session__find_machine_for_cpumode() to return the host 
> > machine always.
> 
> Great, thanks. I will send two patches tomorrow to fix Jason's 
> problem and change the default for perf_guest.

Well, if the crash is fixed then the the default can stay, 
right?

Generally we should treat all input data in a perf.data or even 
the bits we get in the ring-buffer as external data that has to 
be checked carefully, with no assumptions made about data.

Thanks,

	Ingo
