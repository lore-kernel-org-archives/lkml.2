Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab0LXJgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 04:36:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40019 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LXJgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 04:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kROBJMAqsa1F4gdmiqJIAQnuVRL08nze/Vjh2J12kAenapwPuT7scLiM24gDXGDat3
         Rho/0EtXXqCs3gkvs2OUhJRmP8pl0h7rd8GHn5JTTBW35Gn2NRQd0HjxqGEvXjkK4xIN
         fV/SVE4MVBsQH4/Jhd00i1smuqNmE1Ya2sV7A=
MIME-Version: 1.0
In-Reply-To: <1290076370.31469.1.camel@paanoop1-desktop>
References: <1290076370.31469.1.camel@paanoop1-desktop>
Date: Fri, 24 Dec 2010 03:36:09 -0600
Message-ID: <AANLkTim-GzNhC=RwR-caqYtCtpZ6Z--G4focxikT9Ext@mail.gmail.com>
Subject: Re: [PATCH] Fix MSP71xx bpci interrupt handler return value
From: Shane McDonald <mcdonald.shane@gmail.com>
To: Anoop P A <anoop.pa@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Ben Hutchings <ben@decadent.org.uk>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anoop:

On Thu, Nov 18, 2010 at 4:32 AM, Anoop P A <anoop.pa@gmail.com> wrote:
>
> Signed-off-by: Anoop P A <anoop.pa@gmail.com>
> ---
>  arch/mips/pci/ops-pmcmsp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

I have successfully booted a 2.6.37-rc6 kernel with this patch applied
on an MSP7120 Garibaldi evaluation board.

Tested-by: Shane McDonald <mcdonald.shane@gmail.com>
