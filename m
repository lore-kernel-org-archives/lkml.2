Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab2DJOIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:08:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38042 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2DJOIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:08:01 -0400
Date: Tue, 10 Apr 2012 07:07:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Franke <markus.franke@informatik.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/2] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120410140756.GA12537@kroah.com>
References: <4F63AF9E.2090000@hrz.tu-chemnitz.de>
 <20120409220847.GA13124@kroah.com>
 <20120410075532.16392krd825c0ris@mail.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410075532.16392krd825c0ris@mail.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 07:55:32AM +0200, Markus Franke wrote:
> Dear Greg,
> 
> Zitat von Greg KH <gregkh@linuxfoundation.org>:
> 
> >On Fri, Mar 16, 2012 at 10:24:46PM +0100, Markus Franke wrote:
> >>This patch adds a 1-wire slave device driver for the DS28E04-100.
> >>
> >>It applies to the current linux kernel git tree.
> >
> >It's corrupted somehow and doesn't apply at all :(
> >
> >Care to redo this one, and your 2/2 patch, against the 3.4-rc2 release
> >and resend it, with Evgeniy's acks, so that I can apply it?  Please
> >ensure that your email client doesn't mess it up again (hint, it is
> >adding spaces at the front of the line of some parts of the diff.)
> 
> I don't have a clue what might go wrong within my email client.
> Would sending it as an attachement be an option? If not I might have
> to switch to another client.

Have you read Documentation/email_clients.txt yet?

greg k-h
