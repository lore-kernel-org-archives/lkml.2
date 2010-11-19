Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab0KSQZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:25:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52887 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab0KSQZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rs8iJfVpPVRjRAtYmp1tlfAc96muNn1k5rram36sjtGIs+RszJIQUylUF50RcW0CdY
         fuZy5MPRUyL2kEdE9foxO2lYimdu0+HbfpTuRBIc60Q6s+UZgqUeLJEnKal2u5+aplDU
         xi0Z4/ZPdASVYZbb+Xeunu2iyryTgWoKLqP+g=
MIME-Version: 1.0
In-Reply-To: <4CE6A172.7010603@kernel.org>
References: <20101104164401.GC10656@sundance.ccs.neu.edu>
	<4CD3CE29.2010105@kernel.org>
	<20101106053204.GB12449@count0.beaverton.ibm.com>
	<20101106204008.GA31077@sundance.ccs.neu.edu>
	<4CD5D99A.8000402@cs.columbia.edu>
	<20101107184927.GF31077@sundance.ccs.neu.edu>
	<4CD72150.9070705@cs.columbia.edu>
	<4CE3C334.9080401@kernel.org>
	<20101117153902.GA1155@hallyn.com>
	<4CE3F8D1.10003@kernel.org>
	<20101119041045.GC24031@hallyn.com>
	<4CE683E1.6010500@kernel.org>
	<04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com>
	<4CE698C5.5060806@kernel.org>
	<AANLkTikRHuaCpaROtty6X_Oe6JixzgcbVsxHxvtsu+UV@mail.gmail.com>
	<AANLkTikqpv8j-H15qjyhy7RJ92wNsWzeFykVMFKypt13@mail.gmail.com>
	<4CE6A172.7010603@kernel.org>
Date: Fri, 19 Nov 2010 18:25:13 +0200
Message-ID: <AANLkTimUYkzgimgLOtEFDKO6ApY=J2QQxr-mz6AQMmoZ@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kirill Korotaev <dev@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kapil Arya <kapil@ccs.neu.edu>, Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 6:10 PM, Tejun Heo <tj@kernel.org> wrote:
> Well, if you ask me, having pidns w/o a way to reinstate PID from
> userland is pretty silly

No.
Chrome uses CLONE_PID so that exploit couldn't attach to processes in
parent pidns.

> and you and I might not know yet but it's
> quite imaginable that there will be other use cases for the capability
> unlike in-kernel CR.  Kernel provides building blocks not the whole
> frigging package and for very good reasons.

Speaking of pids, pid's value itself is never interesing (except maybe pid 1).
It's a cookie.

CLONE_SET_PID came up only now because only C/R wants it.
