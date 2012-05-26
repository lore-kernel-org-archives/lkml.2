Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2EZPEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 11:04:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46892 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2EZPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 11:04:06 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.41.176]
In-Reply-To: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 26 May 2012 18:03:44 +0300
Message-ID: <CAK=WgbaXw04tEJSQUkCWByWw=yUwqkRxVW9dbFUK8w_64OZkkA@mail.gmail.com>
Subject: Re: [RFC 0/6] remoteproc: custom fw handling
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Tue, May 22, 2012 at 4:26 PM,  <sjur.brandeland@stericsson.com> wrote:
> I have cooked a couple of patches for remoteproc. I was planning to
> test and polish them some more, but figured that I might as well send
> them and find out what you think.

Thanks! I'll give it a good look this week.

> The next five patches are about custom firmware handlers.
> I have done this in small steps to facilitate review, but I
> suspect you might want to squash them all together.

Any chance you have the customer loader patch ready ? Can you submit it too ?

Ideally we should review (and merge) the custom fw groundwork together
with the new fw loader.

> Note that the ELF loaders are not tested. I have no environment to test
> this at the moment.

That's ok, I'll test the ELF part before merging the patch set.

Thanks,
Ohad.
