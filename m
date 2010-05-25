Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0EYRFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:05:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:49780 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab0EYRFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:05:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=j+C92cEQ83NmgrZD1yLLFdX0sLWG9Efv33hTx5jsEPK5mKKAagjTCH9UP3pXt82or
	6CUzia7wB5u4hBurXoZHA==
MIME-Version: 1.0
In-Reply-To: <1274775277.5882.482.camel@twins>
References: <1274746282-21533-1-git-send-email-venki@google.com>
	<1274775277.5882.482.camel@twins>
Date: Tue, 25 May 2010 10:05:15 -0700
Message-ID: <AANLkTikWPkhKz96qteQGYsqTYtuapkDp3SMNfB6IfZuu@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Finer granularity and task/cgroup irq time 
	accounting
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 1:14 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Argh - you managed to use chain-reply with git-1.7?
>

Sorry. My fault.
Had chainreplyto turned on in my gitconfig. :-(. Fixing it now...

Thanks,
Venki
