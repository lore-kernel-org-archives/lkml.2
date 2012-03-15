Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759Ab2COLqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:46:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761690Ab2COLqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:46:31 -0400
Message-ID: <4F61D688.5040406@redhat.com>
Date: Thu, 15 Mar 2012 13:46:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Gleb Natapov <gleb@redhat.com>, Eric Northup <digitaleric@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F60726E.3090807@cn.fujitsu.com> <4F607325.6050607@redhat.com> <20120314104608.GU2304@redhat.com> <4F607789.4010109@redhat.com> <4F607CE4.2060809@cn.fujitsu.com> <4F609822.7050502@redhat.com> <20120314131415.GB2304@redhat.com> <4F609A15.5020902@redhat.com> <20120314132552.GC2304@redhat.com> <CAG7+5M0gEpoJ_jnC8_4Ae-xe2rr7+CJLZh3JjAhh=p=-2bEAcA@mail.gmail.com> <20120315103923.GL2304@redhat.com> <4F61D1AF.4040603@siemens.com>
In-Reply-To: <4F61D1AF.4040603@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 01:25 PM, Jan Kiszka wrote:
> >>
> > There was such vm exit (KVM_EXIT_HYPERCALL), but it was deemed to be a
> > bad idea.
>
> BTW, this would help a lot in emulating hypercalls of other hypervisors
> (or of KVM's VAPIC in the absence of in-kernel irqchip - I had to jump
> through hoops therefore) in user space. Not all those hypercall handlers
> actually have to reside in the KVM module.
>

That is true.  On the other hand the hypercall ABI might go to pieces if
there was no central implementation.

-- 
error compiling committee.c: too many arguments to function

