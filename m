Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1APS6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:58:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab1APS6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:58:06 -0500
MIME-Version: 1.0
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jan 2011 10:57:18 -0800
Message-ID: <AANLkTikWZYOqxD_CyJ=zF2Lp2Mnt6Z2E1aPUspwMjrz_@mail.gmail.com>
Subject: Re: [PATCH v4 00/24] Introduce little endian bitops
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, Russell King <rmk@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 5:08 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> This problem is not touched.

So why not? The thing is supposed to be a cleanup, but it generates
uglier code and more lines added than removed. Why should I pull
something like that?

                    Linus
