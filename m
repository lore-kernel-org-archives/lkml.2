Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0KISYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:24:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545Ab0KISYj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:24:39 -0500
MIME-Version: 1.0
In-Reply-To: <1289281110-8559-1-git-send-email-joe@perches.com>
References: <1289281110-8559-1-git-send-email-joe@perches.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Nov 2010 10:23:25 -0800
Message-ID: <AANLkTime8YvyHysZF5sX6V2mXWJ0FUtdecpVFgRGqYm6@mail.gmail.com>
Subject: Re: [PATCH] include/linux/kernel.h: Move logging bits to include/linux/logging.h
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 9:38 PM, Joe Perches <joe@perches.com> wrote:
> Move the logging bits from kernel.h into logging.h so that
> there is a bit more logical separation of the generic from
> the logging specific parts.
>
> Add pr_<level>_once macros to logging.h.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/kernel.h  |  246 +-----------------------------------
>  include/linux/logging.h |  322 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 324 insertions(+), 244 deletions(-)
>  create mode 100644 include/linux/logging.h

I detest patches like this.

The code movement makes it really hard to see what changed. So if you
do code movement, please do _only_ code movement, and send a separate
patch that actually changes things.

                             Linus
