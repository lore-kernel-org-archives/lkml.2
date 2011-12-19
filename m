Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1LSNIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:08:48 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:35185 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1LSNIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:08:46 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EEF3317.6020304@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <4EEF2382.4010605@redhat.com> <87hb0wbx0p.fsf@abhimanyu.in.ibm.com> <4EEF2729.6080501@redhat.com> <87ehw0bw9v.fsf@abhimanyu.in.ibm.com> <4EEF3317.6020304@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 19 Dec 2011 18:39:58 +0530
Message-ID: <878vm8btcp.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121913-2000-0000-0000-000005C1C116
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 14:50:31 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/19/2011 02:06 PM, Nikunj A Dadhania wrote:
> > The above ebizzy result is from a non-PLE machine, will yield_to come
> > in to picture here?
> 
> No.  I have a soft-PLE patchset but I don't think it's any good.
> 
I had tried your soft-PLE patchset some time back, gang sched was doing
pretty good compared to soft-PLE.

Regards,
Nikunj

