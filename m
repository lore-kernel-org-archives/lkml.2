Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1FWNEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:04:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44726 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1FWNEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Fg/40YY5+olIDHyBBYt5w4Bp5y+peVgD0CD9kwJgfGuVnlbnRNF3HSx+OYJp50WVze
         n2cQ/sZwx8mXlZdSdHkB7mDTuStOqI7hJl8oppGxCD+6TmQEymfBD+Rw00ak+HVEQvnV
         FANIvL9/DTOyGNDsCQI1nhjQis7N60y+v8LfM=
MIME-Version: 1.0
In-Reply-To: <20110623152920.31b28b00.sfr@canb.auug.org.au>
References: <20110623152920.31b28b00.sfr@canb.auug.org.au>
Date: Thu, 23 Jun 2011 16:04:13 +0300
Message-ID: <BANLkTin+iCahNVJGKc-_26pb9zEERTc8_A@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (net tree related)
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 8:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:

I build on all powerpc defconfigs, somehow this driver is not pinned
by any of them :^)

> drivers/net/ll_temac_main.c:209:4: error: implicit declaration of function 'dma_unmap_single'
