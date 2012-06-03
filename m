Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2FCMh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:37:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35545 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab2FCMhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:37:25 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.83.253]
In-Reply-To: <1337693217-15466-2-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com> <1337693217-15466-2-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 3 Jun 2012 15:37:03 +0300
Message-ID: <CAK=WgbY2VE+YB3LYnNGLfgdhGtNN_ELcFhwOh4wEyEr_zx1kNA@mail.gmail.com>
Subject: Re: [RFC 1/6] remoteproc: fix print format warnings
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 4:26 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Fix compile warnings when printing values of type size_t

Looks good, thanks.

Might be nice to add the actual warning in the commit log, and maybe
also specify the version of your gcc (I think you're the first who
reported about these warnings).

Thanks,
Ohad.
