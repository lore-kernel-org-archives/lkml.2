Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1LSNVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:21:20 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36738 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1LSNVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:21:18 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <87k45sbxa6.fsf@abhimanyu.in.ibm.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87k45sbxa6.fsf@abhimanyu.in.ibm.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 19 Dec 2011 18:52:28 +0530
Message-ID: <8762hcbsrv.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121913-8256-0000-0000-0000008C89E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 17:15:05 +0530, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> > 
> > What's behind this huge speedup? Does ebizzy use user-space 
> > spinlocks perhaps? Could we do something on the user-space side 
> > to get a similar speedup?
> > 
> Some more oprofile data here for the above ebizzy-2VM run:
> 
That is readprofile data, kernel booted with profile=2

Nikunj

