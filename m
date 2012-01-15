Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2AOCT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 21:19:27 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43912 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2AOCTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 21:19:25 -0500
MIME-Version: 1.0
In-Reply-To: <1325774407-28531-1-git-send-email-jack@suse.cz>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Jan 2012 18:19:02 -0800
X-Google-Sender-Auth: E3bSR-rppa5Rvhs5DYlkT27Q-rE
Message-ID: <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Edward Shishkin <edward@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 6:40 AM, Jan Kara <jack@suse.cz> wrote:
>
>  for mostly historical reasons we still clear buffer_uptodate flag on write
> IO errors. This is not only semantically wrong (buffer still has correct data
> in it)

That statement is so nonsensical that I can't get past it.

When you understand why it is nonsensical, you understand why the bit
is cleared.

Feel free to bring this up again without that idiotic statement as an argument.

                    Linus
