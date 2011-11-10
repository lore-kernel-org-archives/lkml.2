Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab1KJKnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:43:22 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:40803 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab1KJKnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:43:21 -0500
Date: Thu, 10 Nov 2011 16:13:15 +0530
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
To: Cong Wang <amwang@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Milton Miller <miltonm@bga.com>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Anton Blanchard <anton@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH v4 02/10] fadump: Reserve the memory for firmware
 assisted	dump.
Message-ID: <20111110104315.GB5145@in.ibm.com>
Reply-To: mahesh@linux.vnet.ibm.com
References: <20111107095215.1997.14866.stgit@mars.in.ibm.com>
 <20111107095527.1997.79902.stgit@mars.in.ibm.com>
 <4EBB9FEE.9090905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBB9FEE.9090905@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-10 17:57:02 Thu, Cong Wang wrote:
> Hi, Mahesh,
> 
> Your patch seems have some style problems... checkpatch.pl complains,
> 
> total: 330 errors, 1 warnings, 355 lines checked
> 
> NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
>       scripts/cleanfile
> 
> Could use scripts/checkpatch.pl to check your patch?

I do run the checkpatch.pl before sending patches out. I am not sure how
I missed this one. Will do better job next time.

Thanks,

-- 
Mahesh J Salgaonkar
