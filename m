Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1CWLSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:18:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52575 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1CWLSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FpBDOip2eLmRvJY2Uwgrpf49ABmdPdgd6nBQWb985h/s4lYy8hjw/lCnF2ywNdLOAi
         UE6RU7xSNAx4esTQcXlRtGciXO/2iPgicPUjmEaJkayancKiBmE3bTknD1wUW6LjNvp5
         aFgI5nclXGnmb6ICEYiTY0oB8JXLdxD9BfKag=
MIME-Version: 1.0
In-Reply-To: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
References: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
Date: Wed, 23 Mar 2011 13:18:32 +0200
Message-ID: <AANLkTikuAr9o4fcZi15w1g0kyYehmJBi5ixJ1nmNfw_x@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: build kmemleak-test.c as a module-only
From: Daniel Baluta <daniel.baluta@gmail.com>
To: paulmck@linux.vnet.ibm.com, Catalin Marinas <catalin.marinas@arm.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 8:16 PM, Daniel Baluta <dbaluta@ixiacom.com> wrote:
> mm/kmemleak-test.c is used to provide an example of how kmemleak
> tool works.
>
> Memory is leaked at module unload-time, so building the test
> in kernel (Y) makes the leaks impossible and the test useless.

Any comments on this?

thanks,
Daniel.
