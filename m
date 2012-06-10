Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2FJOrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:47:01 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60727 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2FJOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:47:00 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 10 Jun 2012 17:46:39 +0300
Message-ID: <CAK=WgbZ+KcbQL4cuZjzcmYVUAt1AVyt6Uh6xJJ8yeW90Zt65zg@mail.gmail.com>
Subject: Re: [PATCH 0/7] remoteproc: Custom firmware handling.
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, Jun 6, 2012 at 4:38 PM,  <sjur.brandeland@stericsson.com> wrote:
> I think I have addressed most of your review comments

Thanks! The patches look fairly good, I'm pretty sure we could merge
them very soon.

> except dynamic detection of firmware format.

It could be really nice to have that so we don't have to couple
platforms with specific binary formats.

Is it possible to dynamically detect the STE binary format ? Do you
have some magic string in the header of the file or something ?

> Warning: I have not been able to test this properly,
> I don't yet have a proper test environment running.

Ok, please let me know when you're satisfied with the testing and
would like me to go ahead and do my own pre-merging tests.

Thanks,
Ohad.
