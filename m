Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab2AJRbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:31:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64282 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab2AJRbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:31:12 -0500
MIME-Version: 1.0
In-Reply-To: <87fwfncw1a.fsf@tucsk.pomaz.szeredi.hu>
References: <87k44zdbjm.fsf@tucsk.pomaz.szeredi.hu> <87fwfncw1a.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 09:30:13 -0800
X-Google-Sender-Auth: 0Ow_-ycLzX7IaAu1DdamqUuoM_s
Message-ID: <CA+55aFwSfiXQtJZ6dwOe0UwyoDeW40XkZfOVSiw8ZwavxhDC6w@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: fix shrink_dcache_parent() livelock
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 9:22 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Set flag in prune_dcache_sb() for consistency.  Add stable@ to cc.

Looks good to me.

Al, I'm leaving it to you and forgetting about this issue for now,

                    Linus
