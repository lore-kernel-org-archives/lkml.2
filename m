Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1L1Jya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:54:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab1L1Jy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:54:29 -0500
Message-ID: <4EFAE74F.7000200@redhat.com>
Date: Wed, 28 Dec 2011 11:54:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Liu Ping Fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        gleb@redhat.com, mtosatti@redhat.com, xiaoguangrong.eric@gmail.com,
        jan.kiszka@web.de
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com> <1324975139-8836-1-git-send-email-kernelfans@gmail.com> <4EFAE72D.3080609@redhat.com>
In-Reply-To: <4EFAE72D.3080609@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 11:53 AM, Avi Kivity wrote:
> On 12/27/2011 10:38 AM, Liu Ping Fan wrote:
> > From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> >
> > Currently, vcpu can be destructed only when kvm instance destroyed.
> > Change this to vcpu's destruction before kvm instance, so vcpu MUST
> > and CAN be destroyed before kvm's destroy.
> >
> > Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> > ---
> >  arch/x86/kvm/i8254.c     |   10 +++--
> >  arch/x86/kvm/i8259.c     |   17 +++++--
> >  arch/x86/kvm/x86.c       |   53 +++++++++++-----------
> >  include/linux/kvm_host.h |   20 +++-----
> >  virt/kvm/irq_comm.c      |    6 ++-
> >  virt/kvm/kvm_main.c      |  110 +++++++++++++++++++++++++++++++++++-----------
> >
>
> Documentation/virtual/kvm/api.txt
>

Oops, that's only needed when the unplug API is introduced.

-- 
error compiling committee.c: too many arguments to function

