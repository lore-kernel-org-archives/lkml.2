Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab0HGEBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 00:01:10 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33561 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0HGEBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 00:01:05 -0400
Date: Sat, 7 Aug 2010 06:01:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild: kconfig changes
Message-ID: <20100807040101.GA30520@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This change prevents some the minimal defconfig options from working.
> Specifically our usb gadget drivers do not get set.

Can you help me reproduce this?

I have found an issue with choice values in combination with
tristate logic that fails. I hope this is something similar.

	Sam
