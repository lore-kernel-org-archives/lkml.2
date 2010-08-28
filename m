Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab0H1PIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:08:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40963 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0H1PIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pnahpEkz6OnbYhc51hRRWbqymbH3nDZc3LfsGyYejViWIH1q6SAoU3AgeR4CwPC0CK
         H/N5RzmWj7gC3FfKAhvqKbrL5lQ4QlXR/yn6oRVBk8qq0f8mPlAwc9Law6WD9D88FX1e
         RjbDNQzIb66YZ1gc8ExUPh6G1B9JJomJOrmgc=
MIME-Version: 1.0
In-Reply-To: <20100828142455.601189436@chello.nl>
References: <20100828141637.421594670@chello.nl>
	<20100828142455.601189436@chello.nl>
Date: Sat, 28 Aug 2010 18:08:48 +0300
X-Google-Sender-Auth: o4BuNC-Q5_AnCAh9z-cir79noWQ
Message-ID: <AANLkTim5Bf3ZL49DKz=eN0y6XPst6L1KkVB3kPzePgY3@mail.gmail.com>
Subject: Re: [PATCH 03/20] mm: Rename drop_anon_vma to put_anon_vma
From: Pekka Enberg <penberg@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 5:16 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> The normal code pattern used in the kernel is: get/put.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Pekka Enberg <penberg@kernel.org>
