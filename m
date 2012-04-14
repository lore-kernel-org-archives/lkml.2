Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2DNJbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:31:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53774 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2DNJbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:31:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lubos Lunak <l.lunak@suse.cz>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Date: Sat, 14 Apr 2012 09:30:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Seebach <peter.seebach@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201204132124.21294.l.lunak@suse.cz> <CA+55aFwmZiWfqEF3-Lb_d1jHZQf2Od+oGQ_hfe0CYu8fBTU8nw@mail.gmail.com> <201204141054.23935.l.lunak@suse.cz>
In-Reply-To: <201204141054.23935.l.lunak@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204140930.39643.arnd@arndb.de>
X-Provags-ID: V02:K0:v2455Z0EZBGtmmqAGig0luO9OOwzHmcqm+XQ6q5NNoh
 J8xGrsYpL2jq6uMS7QELSLZrK3ARNmpyrm50TQ6/Kokmrw+0Hh
 RsjtfUyjyLTE9QZqGrbdaGT4fb8whHOg4YFDq2cbvmTtDeD2bR
 lFQTHVp1qiQVkFQQi0eJU65gpYsZg1eL8iv1OHRyuqJd2zVvQR
 GB8c++HZYYrvMvxzzLjue+LO/ULeN3iCvP1qX9N6S1JsNiwMqY
 9zkNBSYleXogMhu9SUNhbxysT7i/KeTkqCKs2ehZC8bY/QkY6N
 RvlCsNPLSMxa4g0R2pzjKIv1utyfWmOttZVyKZauXJ8hsTjXzP
 plwvDnK8acXXL4lIHKN0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 April 2012, Lubos Lunak wrote:
>  That's what the original version of my patch did, but Arnd pointed out that 
> other exported headers might use NULL and thus not be self-contained in 
> userspace after this change, breaking backwards source compatibility. But I'd 
> expect such breakages to be rather unlikely (stddef.h is probably pulled in 
> by pretty much everything), so if you're fine with it, I'm ok with this 
> solution too.

Yes, I stand corrected on that one. I have checked that actually no exported
headers rely on the definition of NULL, so your original patch is good.

Acked-by: Arnd Bergmann <arnd@arndb.de>
