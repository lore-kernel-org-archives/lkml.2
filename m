Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2JVVAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:00:40 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49846 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2JVVAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:00:39 -0400
Date: Mon, 22 Oct 2012 14:00:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Drivers: Staging: CSR: Fixed indentation problems on
 data_tx.c
Message-ID: <20121022210035.GA17805@kroah.com>
References: <n>
 <1350227813-30880-1-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350227813-30880-1-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:16:50AM +0900, Sangho Yi wrote:
> Originally, the data_tx.c was indented with 4 spaces, so I fixed the
> indentation using a single tab.
> 
> Signed-off-by: Sangho Yi <antiroot@gmail.com>
> ---
>  drivers/staging/csr/data_tx.c |   58 ++++++++++++++++++++---------------------
>  1 file changed, 29 insertions(+), 29 deletions(-)

Any reason you modified the same file I did during the presentation?

I've applied my patch already, this one doesn't apply now.

sorry,

greg k-h
