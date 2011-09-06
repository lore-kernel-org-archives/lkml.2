Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1IFHP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 03:15:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33480 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1IFHPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 03:15:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbZVuw3ERa+sbm+RwdBL+JrxmZwpQtjk3mBvtUZVbiNu6g@mail.gmail.com>
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org>
	<201104172239.57362.arnd@arndb.de>
	<4DADB2F1.1080405@linaro.org>
	<201104191810.18170.arnd@arndb.de>
	<CAK=WgbZVuw3ERa+sbm+RwdBL+JrxmZwpQtjk3mBvtUZVbiNu6g@mail.gmail.com>
Date: Tue, 6 Sep 2011 09:15:49 +0200
Message-ID: <CACRpkdY+b9L=9tt2z9Fm_4iM=MOUoRbgaex-UC1iaw=afV-J2w@mail.gmail.com>
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality V2
From: Linus Walleij <linus.walleij@linaro.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 5, 2011 at 11:09 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:

> Looks like this thread has died. Is this driver still needed ?

The driver is still needed.

> If yes, I don't mind picking it up and fixing the outstanding issues,
> as I'm doing some hwspinlock cleanups/fixes right now anyway.

Please do this!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
