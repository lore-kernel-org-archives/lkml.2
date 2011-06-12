Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1FLSIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 14:08:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab1FLSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 14:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <1307879298-sup-3080@shiny>
References: <1307879298-sup-3080@shiny>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 12 Jun 2011 11:08:20 -0700
Message-ID: <BANLkTi=E0GFJPBes4OKAhNiiK9vipT_-+Q@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 4:57 AM, Chris Mason <chris.mason@oracle.com> wrote:
>
> The for-linus branch of the btrfs unstable tree:

Chris, this is getting ridiculous.

You guys need to start honoring the merge window. None of these big
pulls afterwards. If the code wasn't ready, it damn well shouldn't
have been pushed to me in the first place.

I pulled this round, but next pull request had better make it very
clear that it's only minimal *regression* fixes. Nothing more.

                    Linus
