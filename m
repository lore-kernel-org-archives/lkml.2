Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2CZHpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:45:47 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:54177 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2CZHpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:45:44 -0400
Date: Mon, 26 Mar 2012 09:45:07 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/s390/block/dasd_eckd.c: add missing
 dasd_sfree_request
Message-ID: <20120326094507.5521a15c@de.ibm.com>
In-Reply-To: <1332700078-19444-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1332700078-19444-1-git-send-email-Julia.Lawall@lip6.fr>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12032607-8372-0000-0000-00000216E6CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012 20:27:58 +0200
Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Extend some error paths to call dasd_sfree_request as done earlier in the
> function.  The error-handling code is also moved to the end of the function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Good catch, I will add the patch to the s390 tree. Thanks Julia.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

