Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2GISjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:39:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33589 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2GISjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:39:52 -0400
Date: Mon, 9 Jul 2012 11:39:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, aaro.koskinen@iki.fi, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19 v2] Staging: xgifb: Remove LCDA detection in
 xgifb_probe().
Message-ID: <20120709183947.GA21153@kroah.com>
References: <cover.1341569486.git.magomez@igalia.com>
 <0b5331426e8c4fc37b62c58e052526c8c4a28495.1341569486.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b5331426e8c4fc37b62c58e052526c8c4a28495.1341569486.git.magomez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 12:40:38PM +0200, Miguel Gómez wrote:
> The piece of code that checks for LCDA in xgifb_probe() just checks for some
> register values but doesn't really do anything in response to them (the actions
> that should be executed are commented).
> As nothing is really being done, the code can be safely removed.

Are you sure?  Some devices (foolish ones that is) need registers read
to work properly as that is part of their start-up logic.  Yeah, it
doesn't seem to make sense, but hardware designers usually have good
reasons for doing this type of thing.  Or at least they think they do :)

So have you tested the device after this change and it all works
properly?  You do have this device, right?

thanks,

greg k-h
