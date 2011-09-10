Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075Ab1IJU6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 16:58:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933943Ab1IJU6g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 16:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <web-604362530@zbackend1.aha.ru>
References: <web-604362530@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Sep 2011 13:58:10 -0700
Message-ID: <CA+55aFwZ6aWr=PA4G=GNZa2kX04Sp6uasm9XhajqoLkoiss+Xg@mail.gmail.com>
Subject: Re: 3.1-rc5 dont boot
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org, yong.zhang0@gmail.com
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 1:37 PM, werner <w.landgraf@ru.ru> wrote:
> Meanwhile someone mailed me the patch, and I applied it to the code, i.e.
> entry_32.S š . Please verify below that I patched it right.

The file looks correct, but I don't understand what the heck you are doing.

If you really have 3.1-rc5, then you damn well have that commit already.

And if you don't have 3.1-rc5, then the subject line and the previous
report make no sense.

And regardless, the thing I asked you to do was to try to bisect when
it started.

Or try to figure out which config option it is that triggers this problem.

Werner, we've gone through this before. Your craze "everything
enabled" config makes it impossible to figure out what goes wrong,
*especially* when you don't bisect. Read the emails from the previous
time you had problems, and try to narrow it down.

It's totally pointless sending basically the same backtrace over and
over again. It won't help.

                        Linus
