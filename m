Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0J3X2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 19:28:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39573 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab0J3X2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 19:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=llosF7NH8S43zWilc4nc+jcLV4pImsLWz/otkQfQNbBhdrKrxF7aDrQj1+4Fu7D5I+
         n8WZftqSIwO2m7s4b14xMmddOJvUDPfU249R8zku9IkorEJjW8U3+e/Hx/+eT4xxWJR5
         ERW/nSR1GBCuT10fiMmGRb/qPkUOh9cWav3WU=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1010302340260.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302340260.1572@swampdragon.chaosbits.net>
Date: Sun, 31 Oct 2010 08:28:19 +0900
Message-ID: <AANLkTik0hfWygPnBSBPEj2nwgx_Cx0fYoU1h07=ZqM=P@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: remove memset by using kzalloc
From: Minchan Kim <minchan.kim@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 6:43 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> We don't need to memset if we just use kzalloc() rather than kmalloc() in
> kmemleak_test_init().
>
> (please CC on replies)
>
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
