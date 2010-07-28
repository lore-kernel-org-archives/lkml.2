Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0G1SkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:40:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49783 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0G1SkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:40:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LWfyIIXIWzSFUWoYuYw54IOKaLK5XatiK66j9ezMEObP93hW+9P55ARNCbIsjNYaJl
         7TXcVBgQkvDIyAEw6W120sK1c7pAxuPG9peH4gXnrwJxOdee0HqacyimsTtSvAlHE4/4
         04LISpxxLVoONSwbDfgZxisp0s9JukJmhiLA8=
MIME-Version: 1.0
In-Reply-To: <20100728150934.GA25299@suse.de>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
	<1280328052-31292-2-git-send-email-ernesto@ti.com>
	<1280328052-31292-3-git-send-email-ernesto@ti.com>
	<1280328052-31292-4-git-send-email-ernesto@ti.com>
	<1280328052-31292-5-git-send-email-ernesto@ti.com>
	<1280328052-31292-6-git-send-email-ernesto@ti.com>
	<20100728150934.GA25299@suse.de>
Date: Wed, 28 Jul 2010 21:40:19 +0300
Message-ID: <AANLkTimNAoy7fJLeGeUPz2tZT9evUwD58tm7mOxTqqv2@mail.gmail.com>
Subject: Re: [PATCH 5/5] staging:ti dspbridge: replace simple_strtoul by 
	strict_strtoul
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Ernesto Ramos <ernesto@ti.com>, omar.ramirez@ti.com, ohad@wizery.com,
        ameya.palande@nokia.com, felipe.contreras@nokia.com,
        fernando.lugo@ti.com, linux-kernel@vger.kernel.org, nm@ti.com,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 6:09 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Jul 28, 2010 at 09:40:52AM -0500, Ernesto Ramos wrote:
>> Replace simple_strtoul by strict_strtoul in atoi function.
>
> Why not use the built-in kernel function instead of having your own atoi
> function?
The commit message left opened questions about
http://dev.omapzoom.org/?p=tidspbridge/kernel-dspbridge.git;a=commit;h=b8af1123b47741086ef5a307ad1ec8fec6fc7f0d

-- 
With Best Regards,
Andy Shevchenko
