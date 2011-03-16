Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1CPRn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:43:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652Ab1CPRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu>
References: <20110316144253.GT22723@ZenIV.linux.org.uk> <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Mar 2011 10:42:59 -0700
Message-ID: <AANLkTinC2i_+kBjRNFsf8fCKMWJ1zvxAf-A9rf+ZGt-y@mail.gmail.com>
Subject: Re: [git pull] several fixes
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 10:17 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> __fput doesn't need a cdev_put() for O_PATH handles.

"doesn't need" or "must not have"?

                      Linus
