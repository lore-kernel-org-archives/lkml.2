Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1KGSBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:01:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59035 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab1KGSBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:01:20 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111071323450.8485@skynet.skynet.ie>
References: <alpine.DEB.2.00.1111071323450.8485@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Nov 2011 10:00:58 -0800
X-Google-Sender-Auth: n86CIK45cSga3Gfvu-3bi-ra6bY
Message-ID: <CA+55aFy7unJdfb6gz-m-=_5eQH3iFdjK0MKgRoeD5px=CmVQGQ@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 5:27 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> are available in the git repository at:
>
>  ssh://people.freedesktop.org/~/linux drm-fixes

No they are *not* available there.

Fix your pull script already! I mentioned this once earlier, your pull
requests are wrong, and point to things that just don't *exist* for
anybody but you.

I don't have ssh access to that server, and even if I did, that "~"
would be wrong.

                           Linus
