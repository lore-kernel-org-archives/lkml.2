Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0FNT7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:59:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37941 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0FNT7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=J6WPKhztba2a/qK1ritnDeoYP8gL3wFivrV/lyE9+YiRPDu+LtpS4j4Nd8nPm2WWR6
         UNe5s0sT5/B/tZm6U2e38cWHGRCXem+0LI78LPtjootuheYVYGLoBBB8IEPeovKUxOqi
         wJD4HZOcmkIyQ2ySu8hZKZ3W9QTGFgLJ31Vr0=
MIME-Version: 1.0
In-Reply-To: <1276519112-11649-2-git-send-email-matt@console-pimps.org>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org> 
	<1276519112-11649-2-git-send-email-matt@console-pimps.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Jun 2010 15:58:49 -0400
Message-ID: <AANLkTim61KGFgXWlzO71Zqav07AUVazohlcsTmygZaui@mail.gmail.com>
Subject: Re: [PATCH 2/5] blackfin: Remove *(.text.*) pattern from the linker 
	script
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 08:38, Matt Fleming wrote:
> From: Matt Fleming <matthew.fleming@imgtec.com>
>
> Drop the pattern from the linker script because the pattern is now
> provided by TEXT_TEXT.
>
> Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>

once the vmlinux.lds.h change gets merged:
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
