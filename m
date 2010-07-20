Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0GTVRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:17:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54858 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659Ab0GTVRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:17:04 -0400
Date: Tue, 20 Jul 2010 23:16:55 +0200
From: =?UTF-8?B?TWljaGHFgiBHw7Nybnk=?= <gentoo@mgorny.alt.pl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] KERNEL BUILD: Make the setlocalversion script
 POSIX-compliant.
Message-ID: <20100720231655.2226a38b@pomiocik.lan>
In-Reply-To: <4C45ABFD.8060308@suse.cz>
References: <20100718102640.01729af9@pomiocik.lan>
	<4C45ABFD.8060308@suse.cz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 16:00:29 +0200
Michal Marek <mmarek@suse.cz> wrote:

> > There is one 'bashism' left which I wasn't able to fix -- the use of
> > 'test -ef'. I'm not aware of any POSIX equivalent of that.
> 
> Me neither, POSIX does not know stat(1) AFAICS. Does it matter in real
> life? Is there a distro that installs posh or a similarly strict shell
> as /bin/sh? It seems to work with dash after your changes.

I am not aware of any, and it does work with dash indeed. That's why I
have submitted the patch. I left that notice mostly because the actual
description suggested the script becomes 'POSIX-compliant'.

The second reason for that notice is that someone might want to fix
that sometime. But I guess the best way would be through complete
change of the check logic.

-- 
Best regards,
Michał Górny

<http://mgorny.alt.pl>
<xmpp:mgorny@jabber.ru>
