Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0JRHU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:20:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab0JRHU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:20:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] asm-generic/io.h: allow people to override individual funcs
Date: Mon, 18 Oct 2010 09:21:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1287385779-16868-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1287385779-16868-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010180921.24327.arnd@arndb.de>
X-Provags-ID: V02:K0:jRE6fdu9utaFfFfWaAY8ojdSAqfjyJhbIK94lDUMHh1
 AD52mUERau31MDJvD6SDMt7inSuCsKKwu6DIv7PU/T8I/Pyzhk
 Iwwv5gy4V5SUYrCOd9kKvR+uRsnNlD21doJ+7qeXXmRl7TZzI4
 Y2eptcPXlbi56/Nylle51GjVhxB+HjZ9NydH3qLHNBRZuJ5/ux
 wznyT5oFAciltQP4zG/XQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 October 2010, Mike Frysinger wrote:
> For the Blackfin port, we can use much of the asm-generic/io.h header,
> but we still need to declare some of our own versions of functions.
> Like the __raw_read* and in/out "string" helpers.  So let people do
> this easily for many of these funcs.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied, thanks!

	Arnd
