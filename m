Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2E3S1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:27:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34164 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2E3S1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:27:03 -0400
MIME-Version: 1.0
In-Reply-To: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 May 2012 11:26:41 -0700
X-Google-Sender-Auth: IowvCgMEcbudX3u4qVNxi9YB53w
Message-ID: <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com>
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        stable@vger.kernel.org, hughd@google.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 2:02 AM,  <kosaki.motohiro@gmail.com> wrote:
>
> So, I think we should reconsider about shared mempolicy completely.

Quite frankly, I'd prefer that approach. The code is subtle and
horribly bug-fraught, and I absolutely detest the way it looks too.
Reading your patches was actually somewhat painful.

If we could just remove the support for it entirely, that would be
*much* preferable to continue working with this code.

Could we just try that removal, and see if anybody screams?

                  Linus
