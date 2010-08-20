Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0HTR2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:28:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab0HTR2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:28:34 -0400
Date: Fri, 20 Aug 2010 14:28:24 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 08/35] Warn about unstable TSC
Message-ID: <20100820172824.GD2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-9-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-9-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:22PM -1000, Zachary Amsden wrote:
> If creating an SMP guest with unstable host TSC, issue a warning
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Ok, I am not sure I agree 100 % this is needed.
I believe we should try to communicate this kind of thing to the guest,
not the host, and through cpuid.

Passing through tsc flags to the guest should maybe be enough?
