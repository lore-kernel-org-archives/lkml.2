Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2FEPuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:50:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51192 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2FEPuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:50:10 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, dhowells@redhat.com
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
In-Reply-To: <CA+55aFwNWOFj445DQ5i_Jv9dmcteWmveKxQjYx=mso+TkkeJWg@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 5 Jun 2012 08:39:58 -0700")
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
	<CA+55aFwNWOFj445DQ5i_Jv9dmcteWmveKxQjYx=mso+TkkeJWg@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Tue, 05 Jun 2012 17:50:56 +0200
Message-ID: <87lik1iwpr.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Jun 5, 2012 at 6:10 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> This version has one bugfix and several cleanups, reported by David Howells.
>> Also updated documentation in Documentation/filesytems/{vfs.txt,Locking}.
>
> I assume the "one bugfix" is against an earlier version of this
> series, not against the currently merged stuff?

Right, the fix is against the second part of the series, so code
committed into 3.5 shouldn't be affected.

Thanks,
Miklos
