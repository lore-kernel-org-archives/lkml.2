Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab0KISuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:50:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab0KISuN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:50:13 -0500
MIME-Version: 1.0
In-Reply-To: <1289328235.1823.108.camel@Joe-Laptop>
References: <1289281110-8559-1-git-send-email-joe@perches.com>
 <AANLkTime8YvyHysZF5sX6V2mXWJ0FUtdecpVFgRGqYm6@mail.gmail.com> <1289328235.1823.108.camel@Joe-Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Nov 2010 10:49:19 -0800
Message-ID: <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
Subject: Re: [PATCH V2] include/linux/kernel.h: Move logging bits to include/linux/logging.h
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 10:43 AM, Joe Perches <joe@perches.com> wrote:
>
> diff from V1 - Don't add pr_<level>_once macros
>
>  include/linux/kernel.h  |  244 +--------------------------------------
>  include/linux/logging.h |  295 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 296 insertions(+), 243 deletions(-)
>  create mode 100644 include/linux/logging.h

So where do the extra 53 lines come from now?

This still is clearly not just code movement, and it's impossible for
me to see what actually changed. Something must have.

                                 Linus
