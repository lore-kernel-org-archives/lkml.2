Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1ECSsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:48:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1ECSsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:48:07 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] usbnet: Style cleanups
Date: Tue, 3 May 2011 20:49:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1304445019.git.joe@perches.com> <3592918df9ee156047042aae16531e96db0b7144.1304445019.git.joe@perches.com>
In-Reply-To: <3592918df9ee156047042aae16531e96db0b7144.1304445019.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105032049.41433.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Mai 2011, 20:17:57 schrieb Joe Perches:
>  drivers/net/usb/usbnet.c |  625 +++++++++++++++++++++++----------------------
>  1 files changed, 319 insertions(+), 306 deletions(-)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 7bc9852..28aecbb 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -30,8 +30,8 @@
>   * issues can usefully be addressed by this framework.
>   */
>  
> -// #define     DEBUG                   // error path messages, extra info
> -// #define     VERBOSE                 // more; success messages
> +/* #define     DEBUG                   // error path messages, extra info */
> +/* #define     VERBOSE                 // more; success messages */

Hi,

1. please don't touch things like that. They are not comments in a semantic sense
2. If you are touching comments, please redo the multiline comments according to
the coding style.
3. please delay these modifications until the patches against the oom problem have
been applied

	Regards
		Oliver

-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
