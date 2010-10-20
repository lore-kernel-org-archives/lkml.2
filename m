Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0JTMNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:13:08 -0400
Received: from fep21.mx.upcmail.net ([62.179.121.41]:41475 "EHLO
	fep21.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0JTMNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:13:06 -0400
X-Greylist: delayed 1162 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2010 08:13:04 EDT
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH v7 08/12] Handle async PF in a guest.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, mingo@elte.hu,
        tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
        cl@linux-foundation.org, mtosatti@redhat.com
In-Reply-To: <4CBED71D.7040000@siemens.com>
References: <1287048176-2563-1-git-send-email-gleb@redhat.com>
	 <1287048176-2563-9-git-send-email-gleb@redhat.com>
	 <4CBED71D.7040000@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 13:53:31 +0200
Message-ID: <1287575611.3488.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=FfKqumoxTXZ+9nPf2j1EcRvkwAYRHfr8aJLFveX/caA= c=1 sm=0 a=U-5sjxCwodIA:10 a=IkcTkHD0fZMA:10 a=VrKgOesPjC1FQ4wyHzQA:9 a=TKSh8PRq4WZ3bdkH_nn_oonSIcAA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 13:48 +0200, Jan Kiszka wrote:
> > +     case KVM_PV_REASON_PAGE_READY:
> > +             svm->apf_reason = 0;
> > +             local_irq_disable();
> > +             kvm_async_pf_task_wake(fault_address);
> > +             local_irq_enable();
> > +             break;
> 
> That's only available if CONFIG_KVM_GUEST is set, no? Is there anything
> I miss that resolves this dependency automatically? Otherwise, some more
> #ifdef CONFIG_KVM_GUEST might be needed.


Could you please trim your replies?

