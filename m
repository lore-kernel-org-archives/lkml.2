Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1F0N77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:59:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52943 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1F0N7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sw1Dq9VAgDe8fTMR1GSnTh772W39pobbrltBn5egez9NrqiF+UYYLIdY7vFSPN0NUy
         ckn8RVyH8LeirF/ar+zKiQLC6A7EYw8479X9j3ghpJ4x0MGxoVqiWHFF0T36FRNvVePY
         OO+JpsguFG97YsTDDq0pPp0keJmxLWJvzeGl4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
Date: Mon, 27 Jun 2011 15:59:53 +0200
Message-ID: <BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/26 Geert Uytterhoeven <geert@linux-m68k.org>:
> m68k allmodconfig:
>
> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’

We already include slab.h in:
host_pci.c
scan.c
sprom.c

Maybe we can just include this in bcma.h as a better solution? We
could drop other includes then.
Can you submit patch for this?

-- 
Rafał
