Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2LRCP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:15:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2LRCP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:15:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+n7vPVAbx+=Dyd81FfCKQcM9HzHRQBg-JQoBOwu5fZVw@mail.gmail.com>
References: <20121214225125.GA30826@www.outflux.net>
	<CACVXFVMCWZCsMsp=tqYtVy7FYT_A369xFPorC3QwuFW-jTC-ow@mail.gmail.com>
	<CAGXu5j+n7vPVAbx+=Dyd81FfCKQcM9HzHRQBg-JQoBOwu5fZVw@mail.gmail.com>
Date: Tue, 18 Dec 2012 10:15:26 +0800
Message-ID: <CACVXFVMjUZKcKfbjjPfbZNJ91ZFw9XCJO8x6JYgrRb_5WFnmDA@mail.gmail.com>
Subject: Re: [PATCH] firmware: make sure paths remain relative
From: Ming Lei <ming.lei@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 9:37 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Dec 17, 2012 at 5:30 PM, Ming Lei <ming.lei@canonical.com> wrote:
>> On Sat, Dec 15, 2012 at 6:51 AM, Kees Cook <keescook@chromium.org> wrote:
>>> Some devices have configurable firmware locations. If these configuration
>>> mechanisms are exposed to unprivileged userspace, it may be possible to
>>
>> I an wondering how the unprivileged userspace can write the firmware sysfs
>> to trigger loading firmware?
>
> If a daemon were to, for example, make firmware selectable by the user
> (which under certain situations is possible in Chrome OS), it seems
> wasteful require these userspace tools/interfaces to each perform
> filtering, so I figured it would be trivial to put in here instead to
> avoid possible future vulnerabilities.

OK, I understand your concern, and looks reasonable wrt. the specific
problem, and IMO, it is better to provide failure log so that the affected
device driver can be fixed easily.

Thanks,
--
Ming Lei
