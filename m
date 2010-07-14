Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0GNJ1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:27:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44466 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0GNJ1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kdcq0GDxJ01Lcra0H4V40Z5iaWqALJO/1wh5R1jijOE5pk/0ERDGDqPlKOJ0XAYGtl
         gSjMEwP+JgjopZ2Ie7hbZgSyU1LjQzsEPPgt7Ch8GM+2IMA0GqbrGi29OPKJXOV26khO
         e2zpgGBz7PENONRA/DEn0ThfidMv63rvaUvRg=
MIME-Version: 1.0
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Date: Wed, 14 Jul 2010 12:27:01 +0300
Message-ID: <AANLkTikL3FyfN-PqA9f3fIFwqPJtbra5i1T-ETvJXDUa@mail.gmail.com>
Subject: Re: [PATCH 00/11] staging: tidspbridge: header cleanup series
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 1:55 AM, Nishanth Menon <nm@ti.com> wrote:
> Series targetted to remove std.h, GlobalTypes.h and dbdefs.h. These
> introduce custom types and macros which dont make sense for linux kernel
>
> Nishanth Menon (11):
>  staging: tidspbridge: remove custom TRUE FALSE
>  staging: tidspbridge: no need for custom NULL
>  staging: tidspbridge: remove std.h
>  staging: tidspbridge: remove custom typedef reg_uword32
>  staging: tidspbridge: remove RET_OK RET_FAIL
>  staging: tidspbridge: remove GlobalTypes.h
>  staging: tidspbridge: replace CONST with c standard const
>  staging: tidspbridge: remove IN modifier
>  staging: tidspbridge: remove OPTIONAL
>  staging: tidspbridge: remove OUT define
>  staging: tidspbridge: remove dbdefs.h

FWIW: Reviewed-by: Felipe Contreras <felipe.contreras@gmail.com>

-- 
Felipe Contreras
