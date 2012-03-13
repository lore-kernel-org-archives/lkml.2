Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2CMNDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:03:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46292 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2CMNDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <4F5F3E79.5030809@ge.com>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
	<1331572380-1064-5-git-send-email-martyn.welch@ge.com>
	<CACRpkdZv84PKts4jFscsNcOq6rggZXSYzu3CBe8NFDTPwsd1aw@mail.gmail.com>
	<4F5F3E79.5030809@ge.com>
Date: Tue, 13 Mar 2012 14:03:15 +0100
Message-ID: <CACRpkdap9uNJw8nNOSzaFRcah=6Uc2EdNk=ErZHq9Ts4O4kKEw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] powerpc: Board support for GE IMP3A
From: Linus Walleij <linus.walleij@linaro.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/13 Martyn Welch <martyn.welch@ge.com>:
> On 13/03/12 11:51, Linus Walleij wrote:

>> This habit of changing a lot of defconfig stuff in a patch dealing with other
>> stuff is alien in the ARM world. Especially when changing a horde of stuff
>> that has nothing to do with the patch subject.
>>
>
> This is adding the defconfig, it's support for a new board:

Ah I was confused by thinking the patch series was all about GPIO.
Sorry...

Yours,
Linus Walleij
