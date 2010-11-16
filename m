Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab0KPLd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:33:27 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33866 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab0KPLd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:33:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IwfNHyIpp70D/cdFTN3rtSi9j6NSyxovpxMA75CVx6jqo9zEtuja1qmFCa2/gBnqWR
         4dE31MBf/ugGNHC6BIdB4hrUc50nf3MRBiw9S9p8OFEF0QWw24iOdmwEpqYGB3qUc/97
         gAwutcn422YXvsbcFDJw0yBJgAR9VG4bNF6Ps=
MIME-Version: 1.0
In-Reply-To: <1289809300-4038-1-git-send-email-abogani@texware.it>
References: <1289809300-4038-1-git-send-email-abogani@texware.it>
Date: Tue, 16 Nov 2010 06:33:24 -0500
Message-ID: <AANLkTim15YqYThqBw7=GLGbthXdQ836BdWamA4ncSP30@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Update a comment
From: Josh Boyer <jwboyer@gmail.com>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tim Bird <tim.bird@am.sony.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 3:21 AM, Alessio Igor Bogani <abogani@texware.it> wrote:
> The commit 5e3d20a remove bkl from startup code so setup_arch() it isn't called
> with bkl held anymore. Update the comment on top of that function.
>
> This work was supported by a hardware donation from the CE Linux Forum.

You should make sure to send powerpc patches to linuxppc-dev.

>
> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
> ---
>  arch/powerpc/kernel/setup_64.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
> index 2a178b0..71f44e5 100644
> --- a/arch/powerpc/kernel/setup_64.c
> +++ b/arch/powerpc/kernel/setup_64.c
> @@ -497,9 +497,8 @@ static void __init emergency_stack_init(void)
>  }
>
>  /*
> - * Called into from start_kernel, after lock_kernel has been called.
> - * Initializes bootmem, which is unsed to manage page allocation until
> - * mem_init is called.
> + * Called into from start_kernel this initializes bootmem, which is unsed
> + * to manage page allocation until mem_init is called.

You might as well fix the typo while you're there.  unsed->used

josh
