Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab1ACESo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 23:18:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33841 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1ACESn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 23:18:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p0e8BimyrJVr0+f2Ae34LnVA2mKkv6Vb15iS35Yqwbglz1LI00y30ofP2wBPTaFyCg
         O4eaYsdxWX1hclucXCq5b2pukar1v2b9VtizKVjv5JWZxhNAtbn0cXZseJWBByYClqDu
         mopKSIZNl8Asm3L517rYrt3ZKY3q+qkdNU43o=
MIME-Version: 1.0
In-Reply-To: <4D20B38B.40007@redhat.com>
References: <AANLkTikqDDq2GWYONu=JyGkrETMATx14LCFbm+e4PSSZ@mail.gmail.com>
	<4D20B38B.40007@redhat.com>
Date: Mon, 3 Jan 2011 12:18:41 +0800
Message-ID: <AANLkTi=hKcX5Sjei-gNjkknU9O4bZ=bxT9AuSA-US-H4@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Edwin Zhai <edwin.zhai@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 1:19 AM, Rik van Riel <riel@redhat.com> wrote:
> On 01/02/2011 06:43 AM, Hillf Danton wrote:
>
>> The following work is based on what Rik posted, with a few changes.
>
> I threw out my patch before Christmas, replacing it with
> Mike Galbraith's work.
>

Would you please share the work by Mike, or info where to get it?

Hillf

> Today I finally discovered why I had not been getting
> very useful results testing the PLE code on the test
> system.
>
> On this particular CPU model (Intel(R) Xeon(R) CPU X5670),
> the value of ple_gap needs to be at least 48 !
>
> A ple_gap value of 41 is simply too low to trigger reliably
> with Avi's kvm-unit-tests PLE test and also only triggers
> a few times a second at most (not too useful) with the other
> tests I had been running...
>
> --
> All rights reversed
>
