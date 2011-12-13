Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1LMMyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:54:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54236 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1LMMyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:54:07 -0500
Message-ID: <1323780794.9082.16.camel@twins>
Subject: Re: [PATCH tip] sched/trivial: Remove cfs bandwidth period check in
 tg_set_cfs_period()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Date: Tue, 13 Dec 2011 13:53:14 +0100
In-Reply-To: <CAPM31RKR8dvtSmMmV7xO5FnBgY62=fQugXYANNGYMOiAE6iQbg@mail.gmail.com>
References: <20111210135925.GA14593@linux.vnet.ibm.com>
	 <1323695116.13285.14.camel@twins>
	 <CAPM31RKR8dvtSmMmV7xO5FnBgY62=fQugXYANNGYMOiAE6iQbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 04:40 -0800, Paul Turner wrote:
> 
> It's OK though since period is always strictly unsigned so any -ve
> becomes larger than the max allowed period and it spits out -EINVAL as
> appropriate.
> 
> So Kamelesh's patch above is good as is.
> 
> Acked-by: Paul Turner <pjt@google.com> 

Right you are, thanks!


