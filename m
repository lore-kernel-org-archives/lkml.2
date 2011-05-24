Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1EXPhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:37:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43050 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1EXPhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CDc7KJNgOkB8fkUiceSbDRZwSwsbYV+UpsKNoSHYqYoaujd3aMm4KVdPDdyE3wv/nP
         0x/gCEIuZ6fVNqhOZJ+wNjiRspQ1w3LfrQDxiK7xCo0X0ioHqmGFK0LAaHaX6Hwy0A5M
         4GBC85A/iCaZW2468XzNNi/8C8GTzCZyCo0AU=
MIME-Version: 1.0
In-Reply-To: <20110524151910.GA23496@elte.hu>
References: <E1QOrld-0003II-DP@eag09.americas.sgi.com>
	<20110524151910.GA23496@elte.hu>
Date: Tue, 24 May 2011 18:37:11 +0300
X-Google-Sender-Auth: UFW_X1wJUhpgSf-tTOK6JU3BFeM
Message-ID: <BANLkTiknsRgnkM=pQhAzFDe_uCWG-Du7hw@mail.gmail.com>
Subject: Re: [PATCH v5] x86: UV uv_tlb.c cleanup
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 6:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Don't the kfree()s get changed - i.e. the patch has a side-effect?
>
> And yes, while this might be a kmem leak fix, it is a fix and a *SIDE EFFECT*
> which i explicitly asked to be queued in a separate patch(es) from the large
> cleanup patch ...
>
> The cleanup patch should be a cleanup of existing code - even if that code has
> bugs. Nothing more. Bug fixes are for different patches.

There's also renames in the patch that make it pretty hard to review
for correctness. Formatting changes are best done as separate patches.
