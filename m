Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1EGADz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 20:03:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40528 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab1EGADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 20:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=yIKMWtfXmk4UiDIbXPZNHHP/HprmiYsekTR6kfsdjdaAxIgNBWGUAuk6Xke2bGVzx/
         hGPYdUYcXdsAyCnZ4Ydz7n3LjGWBck2KmOY+FYpQuhM9Uff5ABRBb02pwJyWUhBgWAC2
         iUeQYend7ClhuXw1dGSH1XU+ChwG0u4IRelfc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105061355020.5832@router.home>
References: <BANLkTi=Jdxu7am8-jhJbT0t-uhNmW4zWhw@mail.gmail.com>
	<alpine.DEB.2.00.1105061355020.5832@router.home>
Date: Sat, 7 May 2011 03:03:53 +0300
Message-ID: <BANLkTinAw7gxg8Q6D8pK3_pnPpidQa2-bA@mail.gmail.com>
Subject: Re: [PATCH] slub: slub_def.h: needs additional check for "index"
From: Maxin John <maxin.john@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 6, 2011 at 9:56 PM, Christoph Lameter <cl@linux.com> wrote:
> The value passed to kmalloc_slab is tested before the result is used.
> kmalloc_slab() only returns -1 for values > 4MB.
>
> The size of the object is checked against SLUB_MAX size which is
> significantly smaller than 4MB. 8kb by default.
>
> So kmalloc_slab() cannot return -1 if the parameter is checked first.

Thank you very much for pointing it out. I think it's a lot more clear
for me now.

Best Regards,
Maxin
