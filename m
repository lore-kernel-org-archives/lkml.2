Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2LRCDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:03:46 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:46253 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2LRCDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:03:45 -0500
X-Greylist: delayed 1134 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 21:03:45 EST
MIME-Version: 1.0
In-Reply-To: <CACVXFVMCWZCsMsp=tqYtVy7FYT_A369xFPorC3QwuFW-jTC-ow@mail.gmail.com>
References: <20121214225125.GA30826@www.outflux.net>
	<CACVXFVMCWZCsMsp=tqYtVy7FYT_A369xFPorC3QwuFW-jTC-ow@mail.gmail.com>
Date: Mon, 17 Dec 2012 17:37:58 -0800
X-Google-Sender-Auth: A3AY5XP5d2JmiSExZJ3uoHwV83s
Message-ID: <CAGXu5j+n7vPVAbx+=Dyd81FfCKQcM9HzHRQBg-JQoBOwu5fZVw@mail.gmail.com>
Subject: Re: [PATCH] firmware: make sure paths remain relative
From: Kees Cook <keescook@chromium.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 5:30 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Sat, Dec 15, 2012 at 6:51 AM, Kees Cook <keescook@chromium.org> wrote:
>> Some devices have configurable firmware locations. If these configuration
>> mechanisms are exposed to unprivileged userspace, it may be possible to
>
> I an wondering how the unprivileged userspace can write the firmware sysfs
> to trigger loading firmware?

If a daemon were to, for example, make firmware selectable by the user
(which under certain situations is possible in Chrome OS), it seems
wasteful require these userspace tools/interfaces to each perform
filtering, so I figured it would be trivial to put in here instead to
avoid possible future vulnerabilities.

-Kees

-- 
Kees Cook
Chrome OS Security
