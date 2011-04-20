Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1DTGQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:16:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46402 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1DTGQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oJu/WXUhljERL9/t1fS4h11zFZT125f7mSyjvQn8Xt3tZvU4JfHkRti6aYG2/oo+mt
         HAZ4cr9juo6CB2ITpeY7yhh+IT2JIDbYEv0ZSsRX8vl8zYGEDaRTn+NZbVs+vwG3Ik68
         zLJlfxP7uLnf+CSK0DP/rYOwPIkWcPSxvKNYc=
MIME-Version: 1.0
In-Reply-To: <4DAE28F6.30805@snapgear.com>
References: <1303048649-28265-1-git-send-email-akinobu.mita@gmail.com>
	<4DAE28F6.30805@snapgear.com>
Date: Wed, 20 Apr 2011 15:16:47 +0900
Message-ID: <BANLkTinXRdbGSGG0LYgdQ4RZMh38DjF0jA@mail.gmail.com>
Subject: Re: [PATCH] m68knommu: use asm-generic/bitops/ext2-atomic.h
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> m68knommu can use generic implementation of ext2 atomic bitops.
>>
>> Signed-off-by: Akinobu Mita<akinobu.mita@gmail.com>
>> Cc: Greg Ungerer<gerg@uclinux.org>
>
> That looks good to me, so:
>
> Acked-by: Greg Ungerer<gerg@uclinux.org>

Thanks.

> Do you want me to add it to the m68knommu git tree,
> and pass to Linus in the next merge window?

Yes. Please add it to the m68knommu git tree.
