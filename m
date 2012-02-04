Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2BDPZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 10:25:40 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55706 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258Ab2BDPZR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 10:25:17 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzEZ2HwraFa52+N7F11K40hog5DAeU2oSxj+58-hEV=qQ@mail.gmail.com>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
	<CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
	<20120121082857.GC32134@elte.hu>
	<CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
	<20120121165830.GA9216@elte.hu>
	<CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
	<CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
	<CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
	<CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
	<CA+55aFzEZ2HwraFa52+N7F11K40hog5DAeU2oSxj+58-hEV=qQ@mail.gmail.com>
Date: Sun, 5 Feb 2012 00:25:16 +0900
Message-ID: <CAMO-S2jO3pASmqzQrrFEzD_6QzD5BvLH6bTUm3i1PuCnzoMuRw@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 12:05, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 30, 2012 at 7:03 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>  val |= readl(addr+4) << 32;
>
> Oops. That needs a cast to u64 before the shift, of course.
>
> Take all code I write in emails with a pinch of salt - think of it
> more as pseudo-code than something that necessarily would work as-is.
>
>                  Linus

I'll take care, thanks :)


-- 
Hitoshi Mitake
h.mitake@gmail.com
