Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab2FCNtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:49:05 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37761 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2FCNtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:49:03 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.83.253]
In-Reply-To: <CAK=WgbaXw04tEJSQUkCWByWw=yUwqkRxVW9dbFUK8w_64OZkkA@mail.gmail.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com> <CAK=WgbaXw04tEJSQUkCWByWw=yUwqkRxVW9dbFUK8w_64OZkkA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 3 Jun 2012 16:48:42 +0300
Message-ID: <CAK=WgbaR=MYieVJLvOGR_5-2sATb5TGysam=javPhn+qTG9gcA@mail.gmail.com>
Subject: Re: [RFC 0/6] remoteproc: custom fw handling
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

Hi Sjur,

On Sat, May 26, 2012 at 6:03 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, May 22, 2012 at 4:26 PM,  <sjur.brandeland@stericsson.com> wrote:
>> I have cooked a couple of patches for remoteproc. I was planning to
>> test and polish them some more, but figured that I might as well send
>> them and find out what you think.
>
> Thanks! I'll give it a good look this week.

I think that generally this looks very good, thanks for sending this!

There's some small stuff we need to hash out but it looks like we can
nail this pretty quickly.

Thanks,
Ohad.
