Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1D0Htx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:49:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47294 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1D0Htv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W2I0y1h2M8+9v2PUEf/sOP5Ae73Ugpr2Hvft/QtZnRPz2ZTiu/3f+kq08erkZ5+Sv0
         mao/yu2GqvdaUZnwBAOhm8M2rsq4a+12gL39CUd6Nscsrobov0Dd+dYHB1rxEF0NaL74
         vIiF0iboF3kbzFyf9U+i1DydKx17YPFOKsu4U=
MIME-Version: 1.0
In-Reply-To: <1303882443-7613-1-git-send-email-aurelien@aurel32.net>
References: <1303882443-7613-1-git-send-email-aurelien@aurel32.net>
Date: Wed, 27 Apr 2011 17:49:50 +1000
Message-ID: <BANLkTim4LruS4VH4f_VguEr3p6OQrEn3Cg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/radeon: Use pci_dma_mapping_error()
From: Dave Airlie <airlied@gmail.com>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 3:34 PM, Aurelien Jarno <aurelien@aurel32.net> wrote:
> ... instead of comparing with DMA_ERROR_CODE, which will only work on
> powerpc/sparc/x86.
>

So you wrote a patch that breaks it everwhere?

You might want to actually boot this sort of thing before I do, or
read the interface for pci_dma_mapping_error, it doesn't seem to
return what you seem to think it does.

Dave.
