Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2ANXOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 18:14:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41384 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2ANXOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 18:14:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F10751E.8040906@gmx.de>
References: <4F10751E.8040906@gmx.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Jan 2012 15:13:41 -0800
X-Google-Sender-Auth: jP6ddtrlhl0H2SdDyuBmIp-gseI
Message-ID: <CA+55aFz62XPPjnbvdvUAgXRnjaiekwEeNQm-t8KUXgQKZZNeNQ@mail.gmail.com>
Subject: Re: [GIT PULL] fbdev updates for 3.3
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 10:17 AM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
>
> are available in the git repository at:
>  git://github.com/schandinat/linux-2.6.git fbdev-next

Btw, especially since you are using github, I'd *really* like you to
start using signed tags for your pull requests. Even an unsigned gpg
key is better than none, since it at least shows that it's the same
person doing it over time. And I'm sure you can find people who can
sign your key..

               Linus
