Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1GMVSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:18:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:50534 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GMVSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:18:22 -0400
Subject: Re: [RFT][PATCH] sched, cgroup: Optimize load_balance_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Nikhil Rao <ncrao@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <CAPM31R+SCCA-MwPauZn5Va2vJYNs=FdqX+MZqQ0EpwDeyom_RA@mail.gmail.com>
References: <1310557009.2586.28.camel@twins>
	 <CAPM31R+cS+eRaFHa2ygxF3ADYyo5Tf9R+snky3U8b5_am6Wtjg@mail.gmail.com>
	 <1310590968.2586.38.camel@twins>
	 <CAPM31R+SCCA-MwPauZn5Va2vJYNs=FdqX+MZqQ0EpwDeyom_RA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 23:18:17 +0200
Message-ID: <1310591897.2586.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 14:14 -0700, Paul Turner wrote:
> 
> The task_list order was completely arbitrary anyway and had some
> unfair bias against the groups most recently created.

fair enough I guess.
