Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab1KIXXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:23:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62954 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1KIXXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:23:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111109152004.48f15384@tux.DEF.witbe.net>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
 <20111109152004.48f15384@tux.DEF.witbe.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Nov 2011 18:23:00 -0500
X-Google-Sender-Auth: 4k-iAU5mbFGChOl9U_OLMxiZvk0
Message-ID: <CA+55aFy906Le3O8x47qSeA8OqLftos517wo0-PYncYtGO_Jo0w@mail.gmail.com>
Subject: Re: Linux 3.2-rc1
To: Paul Rolland <rol@witbe.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/9 Paul Rolland <rol@witbe.net>:
>
> Is that what made the various tarballs for 3.2-rc1 land
> in /pub/linux/kernel/v3.x and not in testing/ ? ;)

No, that was just my release-script not putting them in the right place.

With the kernel.org security changes, the way I upload the files
changed radically, and my release script was broken. Blush.

             Linus
