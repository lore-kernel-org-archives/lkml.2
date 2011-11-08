Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1KHSH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:07:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41927 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1KHSHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:07:25 -0500
MIME-Version: 1.0
In-Reply-To: <1320767771.14409.389.camel@x61.thuisdomein>
References: <1320767771.14409.389.camel@x61.thuisdomein>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 8 Nov 2011 13:07:03 -0500
Message-ID: <CAMjpGUcw-oTat82ETiZXiEWtoG72PZGPVTC_6-fQL4J4D0uQpg@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] Blackfin: remove bfin_simple_timer.h
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 10:56, Paul Bolle <pebolle@tiscali.nl> wrote:
> Since it was introduced in commit 1394f03221 ("blackfin architecture"),
> bfin_simple_timer.h has always been unused: no file includes it and
> (unsurprisingly) the macros it defines are never used.

there is a driver that is out of tree that uses it, but we haven't
gotten cleaned up for merging.  the header should have been kept as
part of that merge, but i imagine the initial Blackfin support was a
bit hectic (as are all initial arch ports) so it was accidentally
included.
-mike
