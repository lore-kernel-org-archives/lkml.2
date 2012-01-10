Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2AJCCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:02:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56747 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2AJCCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:02:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120110013434.GA23916@ZenIV.linux.org.uk>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu> <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk> <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <20120109205907.GE4198@dastard> <CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
 <20120110013434.GA23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 18:02:10 -0800
X-Google-Sender-Auth: DEo_9c3gziPCqL8L6ixoK0Qx4fs
Message-ID: <CA+55aFzGe6sG0QotpqGpmNJ-HXqMxR5ocmXzvO2wdN_-MnARfA@mail.gmail.com>
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 5:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Dave Chinner (1):
>      dcache: use a dispose list in select_parent

Hmm. Should this also have been marked for stable? I'm assuming that
the possible deadlock (strictly speaking it's a livelock, I guess?)
goes back several releases.

Anyway, it's in my tree now, I suspect it would be good to pick at
least as far back as it trivially applies.

Greg - commit b48f03b319ba78f3abf9a7044d1f436d8d90f4f9.

                           Linus
