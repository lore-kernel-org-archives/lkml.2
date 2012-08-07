Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2HGKiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:38:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52751 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2HGKiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <CANYdXnq1HVpLFZBND=2HextPXCLC5SkewsAqZFhY0KWzWi+rCw@mail.gmail.com>
References: <CANYdXnqCY+Uc=ROvQHv4kRe-g2zoEjfpzV0P83exfXYm-qCBaA@mail.gmail.com>
	<1344327969.20004.2.camel@localhost>
	<5020DB0B.8070103@suse.cz>
	<CANYdXnq1HVpLFZBND=2HextPXCLC5SkewsAqZFhY0KWzWi+rCw@mail.gmail.com>
Date: Tue, 7 Aug 2012 12:38:06 +0200
Message-ID: <CAFLxGvz1Yoj8rFNca88t9N2SjUrTuhuHUuMyBg75AB6XrSiChA@mail.gmail.com>
Subject: Re: A question on serial driver
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Dan Luedtke <mail@danrl.de>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 11:51 AM, Shashidhar Hiremath
<shashidharh@vayavyalabs.com> wrote:
> the code is a bit unclean to send directly. But any information like
> "does driver change modes once it prompts for login"
> can be helpful for debugging since my code does not seem to work after login .

Then clean it up.
You have do to this task anyway.

> Behaviour : Driver prints charecter untill devel login on console. It
> accepts characters before login prompt but doesnot accept the
> charecters after it prompts for login. I enter the username and it is
> not displayed.

There are a gazillion things that could cause this behavior.

-- 
Thanks,
//richard
