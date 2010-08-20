Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0HTQzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0HTQy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:54:59 -0400
Date: Fri, 20 Aug 2010 13:54:48 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 01/35] Drop vm_init_tsc
Message-ID: <20100820165448.GA2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-2-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-2-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:15PM -1000, Zachary Amsden wrote:
> This is used only by the VMX code, and is not done properly;
> if the TSC is indeed backwards, it is out of sync, and will
> need proper handling in the logic at each and every CPU change.
> For now, drop this test during init as misguided.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>

Ok, not a big loose, I agree.

Btw, I suggest we start merging some of those simple
and self-contained patches, before the series grows too big.
Makes it easier for everyone to review the real important stuff.

