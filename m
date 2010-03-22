Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0CVNop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:44:45 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50622 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754483Ab0CVNon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:44:43 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Mon, 22 Mar 2010 14:44:38 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> <200912182052.42477.linux@rainbow-software.org> <200912212054.18055.rusty@rustcorp.com.au>
In-Reply-To: <200912212054.18055.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003221444.39241.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009, Rusty Russell wrote:
> On Sat, 19 Dec 2009 06:22:39 am Ondrej Zary wrote:
> > Generate pnp:d aliases for isapnp_device_tables. This allows udev to load
> > these modules automatically.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> I'm happy with this, so I've separated and taken them.  Too late for the
> merge window I'm afraid, but it'll be in next one.

When will this go in?

-- 
Ondrej Zary
