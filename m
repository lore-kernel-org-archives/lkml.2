Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2FMW5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:57:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63377 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2FMW5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:57:36 -0400
Date: Wed, 13 Jun 2012 15:57:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] small spelling correction
Message-ID: <20120613225732.GA3544@kroah.com>
References: <CAA85sZv1DB7b5Q4j_Qotych+BXAQUCA5Ro2Mer0wDuS07NOnkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA85sZv1DB7b5Q4j_Qotych+BXAQUCA5Ro2Mer0wDuS07NOnkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 06:12:38PM +0200, Ian Kumlien wrote:
> Hi,
> 
> Just saw spotted a spelling error when updating one of my machines to
> 3.4.0-rc7, but since it was so small i actually
> ran hunspell on the config, that's where the adapter change came from
> - hope it's ok =)
> 
> Changes in drivers/usb/host/Kconfig:
> compilant => compliant
> provieds  => provides
> Adaptor   => Adapter

Your patch is attached in base64 mode, making it impossible for me to
apply.  Please use git send-email to send it to me in a format I can
apply it in.

thanks,

greg k-h
