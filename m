Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab0FLPxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 11:53:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:31085 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0FLPxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 11:53:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding;
	b=bMW5lcXABFO2ECcM+nOapPwS0aRqspv2MNdx5UZXnOD07kKbhhbPox8glt64y9StF
	Ieiho7MYA/FpxUaqiP24Q==
MIME-Version: 1.0
In-Reply-To: <20100612071950.GB29751@elte.hu>
References: <20100612023409.14850.76309.stgit@austin.mtv.corp.google.com> 
	<20100612071950.GB29751@elte.hu>
From: Divyesh Shah <dpshah@google.com>
Date: Sat, 12 Jun 2010 08:52:44 -0700
Message-ID: <AANLkTimcB3Jzb0b9pw5YOs5qmeznlcNFOqm64TBqOEdr@mail.gmail.com>
Subject: Re: [PATCH 1/2] Remove preempt_enable/disable calls around 
	sched_clock()
To: Ingo Molnar <mingo@elte.hu>
Cc: jaxboe@fusionio.com, peterz@infradead.org, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 12:19 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Divyesh Shah <dpshah@google.com> wrote:
>
>> calls in the block layer. This was a temporary fix added.
>
> Not good, this commit reintroduces those ugly warnings, if someone happens to
> bisect straight into this commit.

You're right. In the next version, I'll merge both patches into one so
this cannot happen.

>
>        Ingo
>
