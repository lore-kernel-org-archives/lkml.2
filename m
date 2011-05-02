Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab1EBV47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:56:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:59924 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab1EBV46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:56:58 -0400
Subject: Re: linux-firmware tree
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Waychison <mikew@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTinTUdAgF4eQ8_JtWgT_jJB5f7nT-A@mail.gmail.com>
References: <BANLkTimmr=rD84cAkQ2xGsG7PccxQKKqVg@mail.gmail.com>
	 <1304365095.6400.20.camel@macbook.infradead.org>
	 <BANLkTinTUdAgF4eQ8_JtWgT_jJB5f7nT-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 22:56:54 +0100
Message-ID: <1304373414.6400.23.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 14:40 -0700, Mike Waychison wrote:
> I don't see anything in the build (looking at scripts/Makefile.fwinst
> in particular) that allows the build to enumerate out-of-tree firmware
> files required by drivers.  Do you have any thoughts on how this could
> be enumerated? (if it isn't already?)

Using the MODULE_FIRMWARE tags of the drivers which are built.

This is actually the reason we haven't removed the legacy firmware from
the source tree yet; it's waiting for me to implement that bit.

It shouldn't be hard to post-process the modules and list the firmware
blobs that they reference. We'd just want to make it do the same for
built-in drivers too.

-- 
dwmw2

