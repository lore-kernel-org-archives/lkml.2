Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0HMEYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 00:24:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0HMEYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 00:24:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Add fanotify syscalls to <asm-generic/unistd.h>.
Date: Fri, 13 Aug 2010 06:24:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
References: <201008111614.o7BGEVNn016483@farm-0002.internal.tilera.com>
In-Reply-To: <201008111614.o7BGEVNn016483@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008130624.13814.arnd@arndb.de>
X-Provags-ID: V02:K0:o9UEJfXGwjuuaCy7AdHy3IifM66twWkIsKH6M0k4Wr8
 UEmScZZqoB9bC03j9svNM+mC1cvwJLufY+fuFzZg7Bu/S1gPG3
 2CItKexsBiBRLcn5Nol5gxYuvOuYnY0OQCAolEiOSTaDbWwskB
 XNS8NLxJBkY6bzwzOaCheW/DrnwqFRP2njTYsps3+kCubNg3ov
 fNM9WwPJGpcGUoi3szIiQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 August 2010, Chris Metcalf wrote:
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Since I'm currently travelling, I'd prefer not to create a pull request without
having the time for proper testing.

Can you send the appropriate pull request together with any other changes
you might need for Tile?

	Arnd
