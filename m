Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803Ab0GQKAn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 06:00:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56016 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966258Ab0GQKAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 06:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t053gBXqypIuJzCGDBoSYzVxbs8VK4BTFdUowDlb8G8cseeJnx0ySiu1KjKExiCs9J
         0rQpOkA2m4IHDWyi5Ezc6ycYEmjfTo8rcmPe/+va9kYRoJvebrM1YI7Yolh61IgUnAjx
         jeYdAaElN2sye9zoC+6XOCqj0JY8TEXHubkZY=
MIME-Version: 1.0
In-Reply-To: <1279296767-24823-1-git-send-email-segooon@gmail.com>
References: <1279296767-24823-1-git-send-email-segooon@gmail.com>
Date: Sat, 17 Jul 2010 12:00:38 +0200
Message-ID: <AANLkTinb-TcOBX69tjR1Z3OdYmNvDwHMl_-C-39eWyCu@mail.gmail.com>
Subject: Re: [PATCH 02/15] arm/mach-u300: check kmalloc result
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        spi mailing list <spi-devel-general@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/16 Kulikov Vasiliy <segooon@gmail.com>:

>  arch/arm/mach-u300/dummyspichip.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

NACK I have recently submitted two patches to move this test chip to
drivers/spi, please base your fixes work on top of those patches
instead, and make sure to mail them to Grant Likely and the
spi-devel-general list.

Yours,
Linus Walleij
