Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0GIXwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:52:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53123 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab0GIXwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ml9YSMj9ghuJyawxf9eYiGkYmN25ydTY+BG1VYLF0HmX1XHunuvkDw8pY0kxoiICmP
         vvY/BZeUH1o24TurxgiCXgGVUPjEa4dzUnHMjAVkgsTTLPJz3fj1O+oa6sZ1wf3QyOuV
         mXIpw3IKmdsB+3kAm6ZP+nFuRSiW+t51eY0CU=
MIME-Version: 1.0
In-Reply-To: <4C378B32.9060802@canonical.com>
References: <4C378B32.9060802@canonical.com>
Date: Fri, 9 Jul 2010 19:52:38 -0400
Message-ID: <AANLkTim7bpQWiJ-IG3gt8Cwksl4v-GVGtfIEx73R6KNi@mail.gmail.com>
Subject: Re: i915 boot regression on Q35 chipset with 2.6.35-rc4
From: Woody Suwalski <terraluna977@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: airlied@linux.ie,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kees Cook <kees.cook@canonical.com>, chris@chris-wilson.co.uk,
       eric@anholt.net, tim.gardner@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 4:48 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
>
> Dave,
>
> Please find attached a patch that fixes a boot time regression caused by commit f1befe71fa7a79ab733011b045639d8d809924ad. It has been reported to fix at least one user's boot problems.
>
> I think it is also likely the source of the problems reported in http://marc.info/?l=linux-kernel&m=127869783002454&w=2
>
> rtg
> --
> Tim Gardner tim.gardner@canonical.com


Jesse, the above patch
0001-UBUNTU-Upstream-i915-Use-the-correct-mask-to-detect-.patch

is fixing my problem as well. No need for bisecting...

Thanks, Woody

PS. I am sending from GMail Web client - strange things (e.g .HTML)
may happen ;-(
