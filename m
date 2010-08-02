Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab0HBIIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:08:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48371 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0HBIIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=yDO/FCQcrEiq2/tVPsvelT2UJSjIfImdkEP0AEHeQx99/moj/ugUg54HVoT4ZB7ZPu
         vogIEmUUlHIeIJdwtrWXU0JkADcKXsJxo58eAnZkx7qbOm6toiSzbsJ9G4AmUHq5xITb
         0nVc5G4JKEicKzoUdDqYm4DTvAwj6zqjPovAI=
MIME-Version: 1.0
In-Reply-To: <1280711334-30000-12-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
	<1280711334-30000-12-git-send-email-acme@infradead.org>
Date: Mon, 2 Aug 2010 11:08:39 +0300
X-Google-Sender-Auth: D-mD4mEL0SwO9IqkmnqXRQ3qFeE
Message-ID: <AANLkTikds+dU23bsmV+xSG0GX_f3NCesuOokMH7CJMoA@mail.gmail.com>
Subject: Re: [PATCH 11/19] perf record: Release resources at exit
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 4:08 AM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> So that we can reduce the noise on valgrind when looking for memory
> leaks.
>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Yes, please.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
