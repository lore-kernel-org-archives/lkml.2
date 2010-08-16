Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0HPIre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:47:34 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51506 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0HPIrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=TGt0DxPpqv+iznPhstUhIucvnD5N7jfNEdSTDGC9JXTo7ALl7qkpgwnUT0+hslUNKh
         69oLgTtlvJdGT3BL1+cKHNyR0bKnbT4FOjVutyHtsk7Hu3Qt1L09TlOlDRpf/CXDG9qt
         JN9vAUc9DRwFVs7pvRrngTg/oAzayyIUkXc4s=
MIME-Version: 1.0
In-Reply-To: <1281790964.3017.5.camel@localhost.localdomain>
References: <1281790964.3017.5.camel@localhost.localdomain>
Date: Mon, 16 Aug 2010 01:47:31 -0700
X-Google-Sender-Auth: gthcPVVBOBi5Sm_i3-YPkNmFPwQ
Message-ID: <AANLkTinMEcZqX1wLFLJY1GNA1L9kppEwWB1Z883ZgZ+p@mail.gmail.com>
Subject: Re: [PATCH] missing inline keyword for static function in linux/dmaengine.h
From: Dan Williams <dan.j.williams@intel.com>
To: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andre Noll <maan@systemlinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 6:02 AM, Mathieu Lacage
<mathieu.lacage@sophia.inria.fr> wrote:
> Add a missing inline keyword for static function in linux/dmaengine.h to
> avoid duplicate symbol definitions.
>
> Signed-off-by: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>

Applied, thanks.

--
Dan
