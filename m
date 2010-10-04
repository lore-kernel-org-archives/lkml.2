Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0JDN53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:57:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0JDN52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:57:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Belisko Marek <marek.belisko@gmail.com>
Subject: Re: [PATCH 4/6] staging/ft1000-usb: fix problems found by sparse
Date: Mon, 4 Oct 2010 15:56:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <1285835052-11880-1-git-send-email-arnd@arndb.de> <1285835052-11880-5-git-send-email-arnd@arndb.de> <AANLkTikvMWnDQRjqCaMddkRCvhSdij7sN7XPfzNSSYW-@mail.gmail.com>
In-Reply-To: <AANLkTikvMWnDQRjqCaMddkRCvhSdij7sN7XPfzNSSYW-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010041556.53007.arnd@arndb.de>
X-Provags-ID: V02:K0:o30S27zkoLKlF6UCFj3ffcRiFuD4KqcbRXXfxYMxrtF
 vTkJD0FNJch26wwcRN1WP+QLB73f+g9uJD2g5//zK4Ew2IeJXe
 v0qazV2cU2dgpSw0DprQEwGVsDj72/7iDTdUoVe2LwNWFGhuoQ
 WMuy1By7IElYjF0w7jNGdCDDMruQMvu0ontWtemM82laGfZlsA
 AkyjmrHxrQ71WLU+IZX6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 October 2010, Belisko Marek wrote:
> I couldn't apply this patch with git. After manual patching it produce
> compilation errors.
> Did you test it?

Of course I tested it, otherwise I would not have found the build warnings!

Still applies and builds fine here.

	Arnd
