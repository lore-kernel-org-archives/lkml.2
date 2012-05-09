Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab2EINNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:13:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47747 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240Ab2EINNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:13:04 -0400
Date: Wed, 9 May 2012 15:12:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, johnstul@us.ibm.com, arjan@linux.intel.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/5] [x86]: Improve secondary CPU bring-up process
 robustness
Message-ID: <20120509131258.GA24979@gmail.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
 <1336555184.2527.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336555184.2527.6.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> I'm not quite sure how far along he is, but it would be 
> awesome if you could help him out somehow.

bits of Thomas's rework are in latest -tip, the tip:smp/hotplug 
branch, also merged into tip:master and soon to linux-next.

Thanks,

	Ingo
