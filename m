Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1LSLtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:49:36 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39752 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1LSLte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:49:34 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EEF2382.4010605@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <4EEF2382.4010605@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 19 Dec 2011 17:20:46 +0530
Message-ID: <87hb0wbx0p.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121911-2000-0000-0000-000005C180A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 13:44:02 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/19/2011 01:23 PM, Ingo Molnar wrote:
> > What's behind this huge speedup? Does ebizzy use user-space 
> > spinlocks perhaps? Could we do something on the user-space side 
> > to get a similar speedup?
> 
> kvm tries to detect spinlocks (by trapping repeated executions of PAUSE)
> and yield to a related vcpu.  It's far from perfect however, and relies
> on the spinlock code using PAUSE.
> 
Avi, is this soft-PLE kind of thing?

Regards
Nikunj

