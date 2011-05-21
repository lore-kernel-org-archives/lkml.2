Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1EUKi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:38:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33788 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab1EUKi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:38:56 -0400
Date: Sat, 21 May 2011 12:38:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] x86: UV uv_tlb.c cleanup
Message-ID: <20110521103847.GA26447@elte.hu>
References: <E1QNVdB-0008Mk-GP@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QNVdB-0008Mk-GP@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Cliff Wickman <cpw@sgi.com> wrote:

> One logic difference:
> Breaking uv_init_per_cpu() into get_cpu_topology() and summarize_uvhub_sockets()
> actually corrects a possible bug for the theoretical case in which there is a
> missing socket on a blade. An 'smaster' (socket master) had been expected for
> every socket.

Please, as i asked in the previous mail, do not add logic changes to the 
cleanup patch! Please keep it in a separate patch, after the big cleanup patch.

It will be very hard to debug if you find a regression in that cleanup patch: 
since it also changes logic you do not know whether it's due to changed logic 
or one of the cleanups having an unintended side-effect ...

Thanks,

	Ingo
