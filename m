Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2A2CXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 21:23:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53166 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2A2CXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 21:23:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120127230946.GA23528@kroah.com>
References: <20120127230946.GA23528@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 Jan 2012 18:22:41 -0800
X-Google-Sender-Auth: y4yJUr1Z0nKgRVl1_V7v5ZKWCQw
Message-ID: <CA+55aFxeFWnuywj2x5xzQhXg6NWQENpK=n=V1xHvMJZncFhYMQ@mail.gmail.com>
Subject: Re: [GIT PATCH] driver core patches for 3.3-rc1
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 3:09 PM, Greg KH <gregkh@suse.de> wrote:
> I tried to create a signed tag for this pull request.  It's call
> "driver-core-3.3-rc1-bugfixes" in the repo below, but when I did:
>    git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ driver-core-3.3-rc1-bugfixes > msg.txt
>
> I got the text below, no signed tag with the wording that I added to it
> that I could see.  Now I am still using git 1.7.8.3, is that why?  If
> so, I'll go build 1.7.9 as I see that is now out today.
>
> Did I mess something up?  I created the tag with:
>    git tag -u kroah.com -s driver-core-3.3-rc1-bugfixes driver-core-linus

No, everything looks fine, and I just pulled it.

But your old version of git won't be able to do that pull (or
request-pull) since it doesn't have support for the signed tag
feature. So the signed tag itself works fine, and I can pull from you,
but yes, you need to have a newer version yourself to see how that
works.

                  Linus
