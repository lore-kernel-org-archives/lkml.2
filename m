Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2D1D4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 23:56:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48530 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2D1D4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 23:56:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com>
References: <20120427081815.4478.26011.stgit@perseus.themaw.net>
 <CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com> <CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 20:55:54 -0700
X-Google-Sender-Auth: fZ0amrR9OUjhwRhdbQ1ButIurVA
Message-ID: <CA+55aFxGq14x003D8J0TxW33pEO-YrOdp2TrhDfkobZAWh2G+g@mail.gmail.com>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
To: Steve French <smfrench@gmail.com>
Cc: Ian Kent <raven@themaw.net>, Jeff Layton <jlayton@redhat.com>,
        linux-cifs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 8:33 PM, Steve French <smfrench@gmail.com> wrote:
> The fix makes sense, but it is fairly recent and I haven't had a
> chance to try it,
> so unless a new release is imminent, I would prefer to put in the next merge
> request (I have at least one more fix likely as well) next week.

Ok, no problem. Just wanted to check.

                Linus
