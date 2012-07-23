Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2GWSfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:35:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47630 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab2GWSfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:35:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120723152038.GB623@fieldses.org>
References: <20120713173536.GB25432@redhat.com> <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
 <20120723152038.GB623@fieldses.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2012 11:34:56 -0700
X-Google-Sender-Auth: PiYJ-clbU4StsIUf1dJlm0S7nco
Message-ID: <CA+55aFxGuoxbdxy3uKX063vZ1xSRhshRyWf_UhMnDL_by7j9Sg@mail.gmail.com>
Subject: Re: Remove easily user-triggerable BUG from generic_setlease
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 8:20 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
>
> So we need something like the following, backported to 2.6.anything.

Please add a note about the 3.2+ version of this patch (well, totally
different patch), and why this particular patch isn't needed there.

For stable, we should always have a pointer to the patch in mainline,
and if mainline has a different solution, and note about *why*
mainline has that different solution.

             Linus
