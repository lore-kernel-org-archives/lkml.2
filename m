Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab0GGQmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:42:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312Ab0GGQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:42:41 -0400
MIME-Version: 1.0
In-Reply-To: <20100707090808.GA23006@sepie.suse.cz>
References: <20100707090808.GA23006@sepie.suse.cz>
Date: Wed, 7 Jul 2010 09:41:58 -0700
Message-ID: <AANLkTimWtisN1J3EBKcckQ6Ex6jCbfyVcZfeAYYIXmHy@mail.gmail.com>
Subject: Re: [GIT] kbuild
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 2:08 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> my last pull request broke LOCALVERSION for O=... builds, sorry about
> that. The following commit fixes that (verified by Rafael and Stephen
> who reported it. I really hope this is the _last_ kbuild thing for
> 2.6.35.

Hmm. I already applied the patch you sent earlier. It's commit
7263e715c91f in my tree.

                       Linus
