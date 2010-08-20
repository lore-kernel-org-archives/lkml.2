Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0HTWZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:25:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53903 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0HTWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:25:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 04/10] ioctl: Use asm-generic/ioctls.h on frv (enables termiox)
Date: Sat, 21 Aug 2010 00:24:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20100820211401.651509182@suse.com> <20100820211538.515791797@suse.com>
In-Reply-To: <20100820211538.515791797@suse.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008210024.39539.arnd@arndb.de>
X-Provags-ID: V02:K0:ja6H2oEIPDS9VvuUpPXqUtuqj7jCIMuD1JYLUHrqYDc
 L/NLFJsR182OjLdwXi9ebus4mSCvatX32fDoJAkVILx+HWx3Ey
 TeY7JFe013z4+g0vkvGYAo78AL5WRfJ8T/yum8JUWovFCANkb2
 DTIlm5LPnkGhFX3TeWZ55G8d8GBiQD39lUEIgS7GxORxEYbvCQ
 4ohcyx3tQEJAonCc/0piA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 23:14:05 Jeff Mahoney wrote:
> - FRV defines TIOCTTYGSTRUCT, kept in arch-specific version

Pointless, this was removed by the other architecture, and the
same change should be done here, possibly in a separate patch.

	Arnd
