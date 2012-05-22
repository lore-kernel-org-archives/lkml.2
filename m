Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab2EVHEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:04:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41152 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2EVHEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:04:34 -0400
Date: Tue, 22 May 2012 09:04:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: agordeev@redhat.com, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gorcunov@openvz.org
Subject: Re: [PATCH 2/2] x2apic, cluster: use all the members of one cluster
 specified in the smp_affinity mask for the interrupt desintation
Message-ID: <20120522070428.GA15738@gmail.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
 <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> If the HW implements round-robin interrupt delivery, this 
> enables multiple cpu's (which are part of the user specified 
> interrupt smp_affinity mask and belong to the same x2apic 
> cluster) to service the interrupt.

Could/should we do something similar for regular APICs as well? 
They too support masks and LowestPrio delivery - and doing that 
will increase test coverage rather significantly.

Thanks,

	Ingo
