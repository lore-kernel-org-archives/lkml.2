Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0KCNU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:20:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab0KCNU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:20:26 -0400
Date: Wed, 3 Nov 2010 09:20:25 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: gimli <gimli@dark-green.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Resend  [PATCH 3/4] MacbookAir3,1 and 3,2 hid support
In-Reply-To: <3e6b335b371a07cd60221a25c5b6b47d@mognix.dark-green.com>
Message-ID: <alpine.LNX.2.00.1011030918410.15851@pobox.suse.cz>
References: <66c1cd33ff5b2d908b2b31defb8e0cd1@mognix.dark-green.com> <3e6b335b371a07cd60221a25c5b6b47d@mognix.dark-green.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, gimli wrote:

> This patch adds support for the new MacBookAir3,1 and 3,2 to the hid
> driver.
> 
> Updated names names acording Apples kext.
> 
> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>

> -               trans = apple_find_translation((hid->product < 0x21d ||
> +               if(hid->product >= 0x023f && hid->product <= 0x0244 ) {
> +                       trans = apple_find_translation(macbookair_fn_keys, usage->code);
> +               } else {
> +                       trans = apple_find_translation((hid->product < 0x21d ||
>                                        hid->product >= 0x300) ?
>                                        powerbook_fn_keys : apple_fn_keys,
>                                        usage->code);

Could you please make this nicer? Having if and ternary operator both 
there to chose the translation table looks really confusing.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
