Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab0GKUNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 16:13:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:60074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab0GKUNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 16:13:00 -0400
Date: Sun, 11 Jul 2010 22:12:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: samwise <samwise@bagshot-row.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Daniel Oliveira Nascimento <don@syst.com.br>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Qureshi <retro@world3.net>
Subject: Re: [PATCHv1] USB HID DRIVERS: Enable HID_QUIRK_MULTI_INPUT for
 Retro  Adaptor
In-Reply-To: <AANLkTilCk7q_GsrBtxsuNGTwsQMZmUJN7O8e1G0q3fqA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1007112212050.4741@pobox.suse.cz>
References: <AANLkTilCk7q_GsrBtxsuNGTwsQMZmUJN7O8e1G0q3fqA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010, samwise wrote:

> From: Peter Edwards <samwise@bagshot-row.org>
> 
> Patch for linux-2.6.35-rc4 mainline kernel to enable Paul Qureshi's
> Retro Adapter [http://keio.dk/retroadapter.html], an open source USB
> device which allows controllers and joysticks from classic computers
> and consoles to work on modern PCs, to appear as two separate devices
> under Linux.
> Signed-off-by: Peter Edwards <samwise@bagshot-row.org>
> Acked-by: Paul Qureshi <retro@world3.net>
> ---
> 
> This is a first patch submission following the
> Documentation/SubmittingPatches guidelines. Hope this is in the
> correct format for inclusion and is directed at the correct
> maintainer. Please reply if any modifications or further info is
> required.

Hi Peter,

your mail client damaged (whitespaces and line-wrapping) the patch. I have 
fixed it up and applied the patch to my tree, but please keep that in mind 
for your further patch submissions.

Thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
