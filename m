Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2KPSU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:20:26 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40510 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2KPSUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:20:25 -0500
MIME-Version: 1.0
In-Reply-To: <1352795227.9466.8.camel@jlt4.sipsolutions.net>
References: <CAPM=9twSHBet=vDY9q4BXKv7ZUPR-eme75tOzxrWf6Bsp4MMkw@mail.gmail.com>
 <1352795227.9466.8.camel@jlt4.sipsolutions.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Nov 2012 10:20:03 -0800
X-Google-Sender-Auth: ToHaEKi5CXfgAGIHdVG9txmYseQ
Message-ID: <CA+55aFw8Rx6TScXV_nsh4EFeCDTxsjn9mJPqo8VzPhbG9jC5Fw@mail.gmail.com>
Subject: Re: removal of sysfs wext extension broke on F16
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave Airlie <airlied@gmail.com>, John Linville <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 12:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> Should I revert it and send it in my next pull request?

Please do. Or perhaps we could just add the directory back, without
the actual entries, if that is sufficient..

                Linus
