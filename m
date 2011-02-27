Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1B0XoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:44:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64048 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1B0XoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:44:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: klibc@zytor.com
Subject: Re: [klibc] [PATCH] build: Define __EXPORTED_HEADER__
Date: Sun, 27 Feb 2011 21:07:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Mike Waychison <mikew@google.com>,
        linux-kernel@vger.kernel.org
References: <1298506377-16796-1-git-send-email-mikew@google.com> <AANLkTi=8S4=vEUNHR6zD8d1or6BS_o9k4nPg4he+Kik2@mail.gmail.com> <20110226222255.GB24028@merkur.ravnborg.org>
In-Reply-To: <20110226222255.GB24028@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102272107.48934.arnd@arndb.de>
X-Provags-ID: V02:K0:xUc+JBajDzCy9Mz1zRSN7hYrR7uQj+LrWF99KdYnnTs
 Zx41/gbHTJ/IH8P+oAk5jKOHJgWhEKCfKEVF7JQOFyXrPhU0Fk
 W17qTUVHSGP+BReSslUckghEfANfwjFn2ps8tKpq9jNOjVz/x0
 VsBySHvHfvs4gGu+U7tpYD8qA4UbIaNldzm6ehG9LpXIDNJb3b
 l0MMa+g3sMNXqOXWWZ01A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 February 2011, Sam Ravnborg wrote:
> > 
> > What you are proposing seems to me like a step towards giving up on
> > this noble goal :(
> You seem to be confusing something here. Even if klibc is one day
> included in the kernel source then we should continue to use
> the headers generated using "make headers_install" for building klibc.

Absolutely, yes.

Mike, just think of the generated header files as intermediate files
required for building, just like the .o files that are use to build
the library.

	Arnd

