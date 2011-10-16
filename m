Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1JPO0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 10:26:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46001 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1JPO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 10:26:22 -0400
Date: Sun, 16 Oct 2011 16:26:10 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, tomas.winkler@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: mei: clean the TODO file from done tasks.
Message-ID: <20111016142610.GA21921@jak-linux.org>
References: <1318772721-3243-1-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318772721-3243-1-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 03:45:19PM +0200, Oren Weil wrote:
> 1) we move the AMT Watchdog to use the kernel watchdog core and
> it is still part of the MEI Driver, we didn't see any reason to extract it
> from the mei driver now with the new watchdog core.
Not understandable. You need a few transition words instead of just
putting a few unrelated sentences after each other.

> 2) since the watchdog is remains in mei driver, exposing in kernel
> api just for AMTHI unnecessary.
You have a verb (is) too much, and you miss a "the" before
"mei driver". "in kernel" should be "in-kernel", "api" should
be "API". And you miss an "is" after AMTHI (whatever AMTHI
is).

> 
> MEI new Watchdog Core Interface Patches set:
> https://lkml.org/lkml/2011/9/7/26
You are missing a verb here.

> 
> 3) Cleanup the code (init and probe, bug_on usage, headers and etc) was
> submitted in previous patches.
"Code cleanup" instead of "Cleanup the code"

> 
> Patches:
> https://lkml.org/lkml/2011/9/21/231
> https://lkml.org/lkml/2011/6/15/358
> https://lkml.org/lkml/2011/7/7/177
> https://lkml.org/lkml/2011/9/7/38
> https://lkml.org/lkml/2011/9/7/37
> https://lkml.org/lkml/2011/9/7/28
> 
> 
> 4) mei.txt was update with additional information in previous patches.
                      ^	(missing d)

In general, prose text tends to be much more readable than a list
of sentences. At least writing a short introduction in prose would
be helpful.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
