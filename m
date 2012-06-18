Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2FRINr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:13:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46019 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab2FRINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:13:44 -0400
MIME-Version: 1.0
In-Reply-To: <4FDED1E7.6020001@aixigo.de>
References: <4FDC6874.4070106@afaics.de>
	<CAFLxGvxpXBgOH=rhNUdE2FN=mm90sX4-Atwc4k-VrSxoAVZh9A@mail.gmail.com>
	<4FDED1E7.6020001@aixigo.de>
Date: Mon, 18 Jun 2012 10:13:42 +0200
Message-ID: <CAFLxGvzVOru0OAsXuwjoFT29f5Sqx1U2u-FMuJr-3TGdv-K7qw@mail.gmail.com>
Subject: Re: wishlist: vnc framebuffer device?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Harald Dunkel <harald.dunkel@aixigo.de>
Cc: Harald Dunkel <harri@afaics.de>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-console@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 8:59 AM, Harald Dunkel <harald.dunkel@aixigo.de> wrote:
> It is very important to me to get access to the VNC console
> very early in the boot procedure, e.g. if there is a fsck
> asking for help, or if a badly configured root device drops
> me on busybox.

Start the VNC server in your initrd and make sure that it gets
not killed... :-)

-- 
Thanks,
//richard
