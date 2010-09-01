Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0IASki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:40:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50225 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0IASkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=EuekENH2SRs6ELQXIngddYNStZKUyQ/vGUzsVtCWHItFz7pQsoF/DJ1xMgAZLlAZLn
         cbr5Gik8n/eH/CeUdemCUgzXH3SL+cY7mZOLcvI6pjFDKgNEEdqesoUFeN9hKnaXmYcK
         AeQqu8sVDPpFsQtZX/mrW+b6sjS5waA2BLLjY=
MIME-Version: 1.0
In-Reply-To: <1283269738-14612-2-git-send-email-julia@diku.dk>
References: <1283269738-14612-1-git-send-email-julia@diku.dk> <1283269738-14612-2-git-send-email-julia@diku.dk>
From: Timur Tabi <timur@freescale.com>
Date: Wed, 1 Sep 2010 13:40:05 -0500
X-Google-Sender-Auth: UMtoutMIydh67ilk7yj-IjhS07s
Message-ID: <AANLkTikDfFkwKMmn8d1pqUrn+=KL4YH_PE3uXehq-6FG@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/serial/ucc_uart.c: Add of_node_put to avoid
 memory leak
To: Julia Lawall <julia@diku.dk>
Cc: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:48 AM, Julia Lawall <julia@diku.dk> wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_find_compatible_node or of_find_node_by_type.
>
> This patch also substantially reorganizes the error handling code in the
> function, to that it is possible first to jump to code that frees qe_port
> and then to jump to code that also puts np.

Acked-by: Timur Tabi <timur@freescale.com>

Thanks, Julia.

-- 
Timur Tabi
Linux kernel developer at Freescale
