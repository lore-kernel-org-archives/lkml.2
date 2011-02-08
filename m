Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1BHPrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:47:20 -0500
Received: from smtp-out.google.com ([74.125.121.67]:31949 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab1BHPrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:47:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uO8hInVMOyNPr/ENycSW7jpj61XS8C+bgBykS+0hQ1ig+fp1KGeAXn4PPcIZ0lAmbi
         bpLhpVXo+mG11mGCF6Kw==
MIME-Version: 1.0
In-Reply-To: <20110208151925.GC20357@elte.hu>
References: <4d51432a.a7fed80a.1571.fffffe9f@mx.google.com>
	<20110208135144.GE7651@ghostprotocols.net>
	<20110208151925.GC20357@elte.hu>
Date: Tue, 8 Feb 2011 16:47:15 +0100
Message-ID: <AANLkTik9CycDJ4f3wJCEuxDwiwkiEHeEwMu3SYae14zg@mail.gmail.com>
Subject: Re: [PATCH] perf: fix compile error in annotate.h
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 4:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
>
>> Em Tue, Feb 08, 2011 at 02:20:01PM +0200, Stephane Eranian escreveu:
>> > The following patch is necessary to compile without NEWT.
>>
>> Merged already, Borislav Petkov sent a similar patch.
>
> I just pushed it out - Stephane, mind checking that latest -tip indeed fixes things
> for you?
>
Works for me now,  thanks.

Acked-by: Stephane Eranian <eranian@google.com>
