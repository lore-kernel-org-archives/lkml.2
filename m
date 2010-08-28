Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0H1PTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:19:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55760 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0H1PTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NMPr3ievbquZmRb8RSwzTVFZha9awdiLulB3PfXMj1sGbL5I0JWldSZiBGLIzf5LGG
         IJv2MYzHuEwpeHO2x7y/HYmc2plJcrf2KCzLtxi28hN3hoaEJMVYlyt+OKD73NVAjA7C
         6QX/N/56hsCsn5BckvaY975rFYn9Q3qJdiAZE=
MIME-Version: 1.0
In-Reply-To: <20100828141637.421594670@chello.nl>
References: <20100828141637.421594670@chello.nl>
Date: Sat, 28 Aug 2010 18:19:31 +0300
X-Google-Sender-Auth: w6FoyEaCntGJ4QEjEDiaM9Tan1k
Message-ID: <AANLkTikhV6PLb_pRmBmjynft4pe4paKogFP-JR7aXXyv@mail.gmail.com>
Subject: Re: [PATCH 00/20] mm: Preemptibility -v4
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

Hi Peter,

On Sat, Aug 28, 2010 at 5:16 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Yanmin ran the last posting through the comprehensive Intel test farm
> and didn't find any regressions.

Is there data somewhere that shows where this helps and how much?

                        Pekka
