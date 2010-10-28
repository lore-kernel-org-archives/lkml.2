Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab0J1Qbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:31:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab0J1Qbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:31:37 -0400
MIME-Version: 1.0
In-Reply-To: <20101028075631.GA7690@elte.hu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop> <20101028075631.GA7690@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 28 Oct 2010 09:30:51 -0700
Message-ID: <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for 2.6.37)
To: Ingo Molnar <mingo@elte.hu>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 12:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Today's -tip fails to build due to upstream commit 5dabfc7 ("ext4: rename
> {exit,init}_ext4_*() to ext4_{exit,init}_*()"), on all[yes/mod]config with
> CONFIG_EXT4_FS_XATTR disabled:

Btw, could you try to write these things so that the changelog doesn't
have to be totally rewritten? Now I always end up having to move
things around and edit them to be useful from a long-term perspective,
which is kind of silly.

                              Linus
