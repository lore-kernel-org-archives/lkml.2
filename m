Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1ADXi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:38:57 -0500
Received: from ms01.sssup.it ([193.205.80.99]:59347 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751257Ab1ADXiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:38:55 -0500
Message-ID: <4D23AF8A.6080306@sssup.it>
Date: Wed, 05 Jan 2011 00:38:50 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, a.p.zijlstra@chello.nl
CC: Dario Faggioli <faggioli@gandalf.sssup.it>,
        Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>, riel@redhat.com,
        Hillf Danton <dhillf@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Fwd: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function]
References: <1294164920.6169.199.camel@Palantir>
In-Reply-To: <1294164920.6169.199.camel@Palantir>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/01/2011 19:15, Dario Faggioli ha scritto:
>
> -------- Forwarded Message --------
> From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> To: Rik van Riel<riel@redhat.com>
> Cc: Hillf Danton<dhillf@gmail.com>,kvm@vger.kernel.org,
> linux-kernel@vger.kernel.org, Avi Kiviti<avi@redhat.com>, Srivatsa
> Vaddagiri<vatsa@linux.vnet.ibm.com>, Mike Galbraith<efault@gmx.de>,
> Chris Wright<chrisw@sous-sol.org>
> Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
> Date: Tue, 04 Jan 2011 19:05:54 +0100
> RT guests don't make sense, there's nowhere near enough infrastructure
> for that to work well.
>
> I'd argue that KVM running with RT priority is a bug.
Peter, can I ask why did you state that ? In the IRMOS project, we
are just deploying KVM VMs by using the Fabio's real-time scheduler
(for others, a.k.a., the Fabio's EDF throttling patch, or IRMOS RT 
scheduler)
in order to let the VMs get precise CPU scheduling guarantees by the
kernel. So, in this context we do have KVM running at RT priority, and
we do have experimental results showing how this can improve stability
of performance of the hosted guest VMs.
Of course, don't misunderstand me: this is a necessary condition for a
stable performance of KVM VMs, I'm not saying it is sufficient for

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

