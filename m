Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2JVVCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:02:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:41626 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2JVVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:02:44 -0400
Date: Mon, 22 Oct 2012 14:02:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Drivers: Staging: CSR: Removed braces for single
 line if statement
Message-ID: <20121022210241.GA23741@kroah.com>
References: <n>
 <1350227813-30880-1-git-send-email-antiroot@gmail.com>
 <1350227813-30880-2-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350227813-30880-2-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:16:51AM +0900, Sangho Yi wrote:
> It was a very minor fix that an if statement had curly braces with just
> single line of code inside.
> 
> Signed-off-by: Sangho Yi <antiroot@gmail.com>
> ---
>  drivers/staging/csr/data_tx.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Doesn't apply as I already did this patch :(

greg k-h
