Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab0HTRav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:30:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab0HTRar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:30:47 -0400
Date: Fri, 20 Aug 2010 14:30:38 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
Message-ID: <20100820173038.GE2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-11-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-11-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:24PM -1000, Zachary Amsden wrote:
> When CPUs with unstable TSCs enter deep C-state, TSC may stop
> running.  This causes us to require resynchronization.  Since
> we can't tell when this may potentially happen, we assume the
> worst by forcing re-compensation for it at every point the VCPU
> task is descheduled.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Fair enough.

