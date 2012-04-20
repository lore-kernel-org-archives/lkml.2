Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2DTSUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:20:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59089 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab2DTSTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120420153134.GA32324@google.com>
References: <20120420153134.GA32324@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Apr 2012 11:19:12 -0700
X-Google-Sender-Auth: trun2J0tqqmxPcPx3dFf3DHtx_Y
Message-ID: <CA+55aFxHTUFaRff02geFQWU6ahC+POgENc6KswkZ6X=iewH89w@mail.gmail.com>
Subject: Re: [PATCH 3.4-rc3] memblock: memblock should be able to handle zero
 length operations
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org, Valere Monseur <valere.monseur@ymail.com>,
        Joseph Freeman <jfree143dev@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 8:31 AM, Tejun Heo <tj@kernel.org> wrote:
>
> This is causing early panics if anyone tries to reserve zero len area,
> which unfortunately isn't too uncommon depending on BIOS.  The fix is
> fairly safe.  Unsure which tree it should go through.  Cc'ing Linus
> and Ingo.

Applied,

              Linus
