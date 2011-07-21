Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1GUSR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:17:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61533 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1GUSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:17:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110721181601.31646.18252.stgit@beardog.cce.hp.com>
References: <20110721181601.31646.18252.stgit@beardog.cce.hp.com>
Date: Thu, 21 Jul 2011 13:17:23 -0500
Message-ID: <CADzpL0R3Eh4LsdCute15GsYM5BcSxWoJ_haVAxmDkj8fBe3crw@mail.gmail.com>
Subject: Re: [PATCH] cciss: do not attempt to read from a write-only register
From: Stephen Cameron <stephenmcameron@gmail.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 1:16 PM, Stephen M. Cameron
<scameron@beardog.cce.hp.com> wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Most smartarrays will tolerate it, but some new ones don't.
> Without this change some newer Smart Arrays will lock up
> and i/o will grind to a halt.
>

Noticed this wasn't in Linus's git tree yet, so resent it.

-- steve
