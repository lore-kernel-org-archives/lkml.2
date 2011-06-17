Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1FQVQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:16:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57726 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1FQVQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=U9C548jZiIWnrfNPjIRZ2ldGdiBPnmO50/R/k6szwMM4jAJ7pfedAiXXe5CygXO/DX
         0SHYI2Fp6128HSwkFD/sndz+7nzwiSNVZEkWWc6V8J/So5o9tWfmhyKfoeAbHaSN5DA8
         JqxfXJB9fm5ACJoe9iiKU3vLwZposda+S20Lg=
MIME-Version: 1.0
In-Reply-To: <1308345046-13293-1-git-send-email-vapier@gentoo.org>
References: <1308345046-13293-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 17 Jun 2011 17:16:28 -0400
X-Google-Sender-Auth: 7R1FOCnuUh89loXKaP9Fw4lGRA4
Message-ID: <BANLkTimqW53BHCGkr0+2ryFduOvLCzPMFA@mail.gmail.com>
Subject: Re: [PATCH] asm-generic/atomic.h: allow SMP peeps to leverage this
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 17:10, Mike Frysinger wrote:
> +/* Force people to define core atomics */
> +# if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
> +     !defined(atomic_clear_mask) || !defined(atomic_set_mask) || \
> +     !defined(atomic_test_mask)

hmm, pause on this.  these mask funcs are not as standardized as i'd
hope.  i'll send another patch fixing that and then redoing this on
top of it.
-mike
