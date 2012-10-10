Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2JJIFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 04:05:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48100 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2JJIE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 04:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <20121009164040.GV2616@ZenIV.linux.org.uk>
References: <50700A1A.7@gmail.com>
	<50734C6D.2000400@panasas.com>
	<20121008232447.GR2616@ZenIV.linux.org.uk>
	<507448E0.4040305@gmail.com>
	<20121009164040.GV2616@ZenIV.linux.org.uk>
Date: Wed, 10 Oct 2012 10:04:58 +0200
Message-ID: <CANGUGtDujPGwbgYTQPdPXTg5WQ8Nyj+O7_tGyUm5EnDgs+Z3xQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] exofs: drop lock/unlock super
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/9 Al Viro <viro@zeniv.linux.org.uk>:
> On Tue, Oct 09, 2012 at 05:55:12PM +0200, Marco Stornelli wrote:
>
>> Thanks Al. For me there aren't problems to push it via Al or via
>> other trees. For example the patch for ext4 is in Ted's tree. You
>> tell me what you want and I do it :)
>
> Um...  Then I'd better drop the ext4 part and hold the final one back,
> right?  Are there other commits I need to skip to avoid duplicates with
> the stuff already in other trees?

No, or at least I know that only Ted (for ext4) has included the patch
in his tree, so no other problem.

Marco
