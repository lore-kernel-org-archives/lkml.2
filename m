Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1ADRMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:12:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1ADRMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:12:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VBiU8/4XeQCiLy2qGfyzIfHFWJGffEVq9r6DQSr9UUdJ3OUbHenpoOke5vIPMtSQe4
         WRx1yPUtk7Y7xB5FUL4lBJBSAFdfMfmAn0EF1lADEf9RMmdQ6GDgUCwOwSBGU0m2dJ51
         31RzkxUqMJF2hOSHRJ/5y0XzSokBmcNEGc+Fs=
MIME-Version: 1.0
In-Reply-To: <1294160890.2016.171.camel@laptop>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	<20110103162918.577a9620@annuminas.surriel.com>
	<AANLkTim1UFzHjBv52p7tyVyXerCVUVOBSAa3ajwQveuN@mail.gmail.com>
	<4D234E60.3010804@redhat.com>
	<AANLkTim8zmhKjPs-fVdR=65VPd6hybD8HA8pKEyKzm13@mail.gmail.com>
	<1294160890.2016.171.camel@laptop>
Date: Wed, 5 Jan 2011 01:12:45 +0800
Message-ID: <AANLkTimJMF+4VQ39zTRorqFXYKy9sJ1xwUWTxyUG4M2R@mail.gmail.com>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 1:08 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2011-01-05 at 00:51 +0800, Hillf Danton wrote:
>> Where is the yield_to callback in the patch for RT schedule class?
>> If @p is RT, what could you do?
>
> RT guests are a pipe dream, you first need to get the hypervisor (kvm in
> this case) to be RT, which it isn't. Then you either need to very
> statically set-up the host and the guest scheduling constraints (not
> possible with RR/FIFO) or have a complete paravirt RT scheduler which
> communicates its requirements to the host.
>
Even guest is not RT, you could not prevent it from being preempted by
RT task which has nothing to do guests.
