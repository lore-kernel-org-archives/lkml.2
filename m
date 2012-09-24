Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2IXMkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:40:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35622 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2IXMkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:40:11 -0400
MIME-Version: 1.0
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 24 Sep 2012 14:39:49 +0200
Message-ID: <CAK1hOcMongS_p5+oiaqE85tEVF8mv+SCm3yb-N=Zqz4Xuz_+WA@mail.gmail.com>
Subject: parisc: orphaned asm/compat_signal.h file?
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed the following:

In linux-mmotm and parisc-2.6.git trees,
arch/parisc/include/asm/compat_signal.h file is just:


/* Use generic */
#include <asm-generic/compat_signal.h>


which isn't correct since asm-generic/compat_signal.h doesn't exist.

Nobody noticed this because arch/parisc/include/asm/compat_signal.h
itself is not included by any other file.

Maybe it needs to be removed?

-- 
vda
