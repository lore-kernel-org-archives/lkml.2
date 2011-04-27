Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1D0KIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:08:15 -0400
Received: from hall.aurel32.net ([88.191.126.93]:46734 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524Ab1D0KIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:08:13 -0400
Date: Wed, 27 Apr 2011 12:08:06 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Dave Airlie <airlied@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/radeon: Use pci_dma_mapping_error()
Message-ID: <20110427100806.GA20115@volta.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Dave Airlie <airlied@gmail.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1303882443-7613-1-git-send-email-aurelien@aurel32.net>
 <BANLkTim4LruS4VH4f_VguEr3p6OQrEn3Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <BANLkTim4LruS4VH4f_VguEr3p6OQrEn3Cg@mail.gmail.com>
X-Mailer: Mutt 1.5.20 (2009-06-14)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 05:49:50PM +1000, Dave Airlie wrote:
> On Wed, Apr 27, 2011 at 3:34 PM, Aurelien Jarno <aurelien@aurel32.net> wrote:
> > ... instead of comparing with DMA_ERROR_CODE, which will only work on
> > powerpc/sparc/x86.
> >
> 
> So you wrote a patch that breaks it everwhere?

It seems I inverted the condition yes.

> You might want to actually boot this sort of thing before I do, or
> read the interface for pci_dma_mapping_error, it doesn't seem to
> return what you seem to think it does.

I tried, but I don't have such a card, so it doesn't trigger the bug.
I'll send a v2 soon.

-- 
Aurelien Jarno                          GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net
