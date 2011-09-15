Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934906Ab1IOUpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:45:06 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:40337 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934721Ab1IOUpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <1316117394-21666-8-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
	<1316117394-21666-8-git-send-email-andi@firstfloor.org>
Date: Thu, 15 Sep 2011 16:45:03 -0400
Message-ID: <CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com>
Subject: Re: [PATCH 07/27] Initconst section fixes for POWERPC
From: Josh Boyer <jwboyer@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 4:09 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>

What's the problem again?

> Cc: benh@kernel.crashing.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/powerpc/platforms/40x/ppc40x_simple.c    |    2 +-

<snip>

> diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
> index e8dd5c5..d6ed100 100644
> --- a/arch/powerpc/platforms/40x/ppc40x_simple.c
> +++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
> @@ -50,7 +50,7 @@ machine_device_initcall(ppc40x_simple, ppc40x_device_probe);
>  * Again, if your board needs to do things differently then create a
>  * board.c file for it rather than adding it to this list.
>  */
> -static const char *board[] __initdata = {
> +static const char * const board[] __initconst = {
>        "amcc,acadia",
>        "amcc,haleakala",
>        "amcc,kilauea",

There's an almost identical section in
arch/powerpc/platforms/44x/ppc44x_simple.c.  Does that need whatever
this is fixing as well?

josh
