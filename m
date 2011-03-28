Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1C1WgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:36:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878Ab1C1WgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <1301312919-sup-1222@think>
References: <1301312919-sup-1222@think>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Mar 2011 15:35:14 -0700
Message-ID: <AANLkTikYvGZHfqCsNOUzBE+24-5Pxxk=t294BfSXJhKs@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.39
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 5:08 AM, Chris Mason <chris.mason@oracle.com> wrote:
>
> Linus, I've pushed out two branches for you, for-linus and
> for-linus-unmerged

Thanks. I took the unmerged one, because I do like to see what's going
on. But I did end up verifying the end result against your merge, and
it ended up identical, so we're all good.

                           Linus
