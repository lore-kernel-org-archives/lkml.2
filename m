Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1GUMAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:00:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1GUMAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:00:06 -0400
Date: Thu, 21 Jul 2011 14:00:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Don Prince <dhprince.devel@yahoo.co.uk>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: prodikeys: remove a redundant forward declaration
 of struct pcmidi_snd
In-Reply-To: <1311234448.16867.0.camel@phoenix>
Message-ID: <alpine.LNX.2.00.1107211359590.7300@pobox.suse.cz>
References: <1311234448.16867.0.camel@phoenix>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011, Axel Lin wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/hid/hid-prodikeys.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
> index ab19f29..53c9850 100644
> --- a/drivers/hid/hid-prodikeys.c
> +++ b/drivers/hid/hid-prodikeys.c
> @@ -44,8 +44,6 @@ struct pk_device {
>  	struct pcmidi_snd	*pm; /* pcmidi device context */
>  };
>  
> -struct pcmidi_snd;
> -
>  struct pcmidi_sustain {
>  	unsigned long		in_use;
>  	struct pcmidi_snd	*pm;

Applied.

-- 
Jiri Kosina
SUSE Labs
