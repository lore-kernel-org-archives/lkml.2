Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0CVHQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:16:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42857 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0CVHQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:16:20 -0400
Message-ID: <4BA71949.9040809@cs.helsinki.fi>
Date: Mon, 22 Mar 2010 09:16:25 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
References: <1269210658-9518-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1269210658-9518-1-git-send-email-lindley@coyote.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Lindley kirjoitti:
> I fixed the checkpatch things except a couple of long lines.
> I also removed hungarian notation from the argument names
> and some "commented away" code.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

Did you check that all these function declarations are actually used? 
I've spotted plenty of dead code in the past.

> +/*
> + * ====================================
> + * Interface function declare
> + * ====================================
> + */
> +unsigned char Wb35Reg_initial(struct hw_data *HwData);

Lets avoid CamelCase for the arguments so "hw_data" here, for example. I 
see the same thing elsewhere in this patch as well.
