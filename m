Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1BXVzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:55:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056Ab1BXVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:55:22 -0500
Date: Thu, 24 Feb 2011 13:55:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update obsolete email addresses for Lennert Buytenhek.
Message-Id: <20110224135521.990c3f35.akpm@linux-foundation.org>
In-Reply-To: <20110222144826.GH2189@mail.wantstofly.org>
References: <20110222144826.GH2189@mail.wantstofly.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 15:48:27 +0100
Lennert Buytenhek <buytenh@wantstofly.org> wrote:

> Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> 
> diff --git a/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c b/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
> index 1e5266f..116ff8f 100644
> --- a/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
> +++ b/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
> @@ -162,7 +162,7 @@ static int __init mv88f6281gtw_ge_pci_init(void)
>  subsys_initcall(mv88f6281gtw_ge_pci_init);
>  
>  MACHINE_START(MV88F6281GTW_GE, "Marvell 88F6281 GTW GE Board")
> -	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
> +	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */

 36 files changed, 36 insertions(+), 36 deletions(-)

Could I suggest that you just remove all the email addresses from those
files?  use plain old "Lennert Buytenhek".  People can then use that as
a search key in MAINTAINERS, so there is then only one email address
which needs to be maintained.

