Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab0HTNoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:44:08 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:58994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0HTNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:44:07 -0400
Subject: Re: 2.6.36-rc1 -- BUG: kmalloc-4096: Object already free -- INFO:
 Allocated in wireless_send_event+0x21d/0x344
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <AANLkTinNw9859ihV4VM=x7sQuF0aoSw1asc0_EujXXrC@mail.gmail.com>
References: <AANLkTinNw9859ihV4VM=x7sQuF0aoSw1asc0_EujXXrC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 15:44:02 +0200
Message-ID: <1282311842.3793.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 12:20 -0700, Miles Lane wrote:
> Is this indicative of a kernel bug or just problems with userspace apps?
> 
> [   44.455666] BUG kmalloc-4096: Object already free
> [   44.455670] -----------------------------------------------------------------------------
> [   44.455673]
> [   44.455685] INFO: Allocated in wireless_send_event+0x21d/0x344
> age=0 cpu=1 pid=635

It's a bug that even exists in 2.6.35, fixed here:

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=daa3766e705c2605bd7f63b80c7742014ef9e04e
http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=68d6ac6d2740b6a55f3ae92a4e0be6d881904b32

johannes

