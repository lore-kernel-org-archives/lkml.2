Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab0JDTX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:23:28 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38795 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab0JDTX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:23:27 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
Date: Mon, 4 Oct 2010 21:24:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, pingc@wacom.com,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
References: <4C8E180D.4020309@suse.cz> <201010042033.53453.oliver@neukum.org> <20101004183848.GG8321@core.coreip.homeip.net>
In-Reply-To: <20101004183848.GG8321@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010042124.24253.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. Oktober 2010, 20:38:49 schrieb Dmitry Torokhov:
> On Mon, Oct 04, 2010 at 08:33:53PM +0200, Oliver Neukum wrote:
> > Am Montag, 4. Oktober 2010, 18:13:20 schrieb Dmitry Torokhov:
> > > Lost track of this issue for a while. So I think we still need to fix
> > > the deadlock for .36 and I think that the following will do that. Then
> > > we'll adjust the driver to actually enable runtime PM for .37.
> > 
> > That's a viable plan.
> > 
> 
> I take it as an "acked-by" for this patch, right?

Sure. Just in case:

Acked-by: Oliver Neukum <oneukum@suse.de>

	HTH
		Oliver


