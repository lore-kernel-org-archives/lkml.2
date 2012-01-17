Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab2AQBtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:49:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40235 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2AQBtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:49:31 -0500
Date: Tue, 17 Jan 2012 02:49:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Fubo Chen <fubo.chen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] selftests: New very basic kernel selftests directory
Message-ID: <20120117014924.GC24200@somewhere.redhat.com>
References: <1322840475-19553-1-git-send-email-fweisbec@gmail.com>
 <CAJAFBLCP=4_nuExevTsyuVOBw4BH0h7Gk=qQqaOFxohZafwRbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJAFBLCP=4_nuExevTsyuVOBw4BH0h7Gk=qQqaOFxohZafwRbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 06:54:27PM +0000, Fubo Chen wrote:
> On Fri, Dec 2, 2011 at 3:41 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Bring a new kernel selftests directory in tools/testing/selftests.
> 
> Interesting ... but why to invent a test framework from scratch while
> there already exists stuff like googletest or TAP::Harness ?

We wanted to start with something very simple that just launch
selftests in batch.

Let's see first where this goes, if this becomes a useful subsystem that
grows up, then if it makes sense to rely on some more elaborated selftest
framework we can think about it.
