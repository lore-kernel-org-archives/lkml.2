Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0H3KwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:52:16 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46857 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0H3KwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=vTjqXjm9nRrYbXmzKHOhzWlL1lbXd3D3u5mpU0D/tmkYJhxVxlodSIYSQkCJgfCaCJ
         9Kb989P2uqD8UwV76kDOqOi94XmxSKjboFI4iIDgyjHiptWsMqzF/DnLnZTueMbsz7AP
         TC4LxBTxKrZ28n92tD+CmT951Fk4hNcZ44Ypk=
MIME-Version: 1.0
From: Paolo Cancedda <paolo.cancedda@gmail.com>
Date: Mon, 30 Aug 2010 12:51:53 +0200
Message-ID: <AANLkTinSidYTVEBQeP2pmXsa5prh0B6vVYPj63G_Jo4f@mail.gmail.com>
Subject: Re: What reassert_nmi() in default_do_nmi() is for?
To: linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>,
        Paolo Cancedda <paolo.cancedda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The implementation of reassert_nmi is as follow:
>
> [...]
>
> I can not understand the code and the logic. Can anyone explain it in
> more detail?

It's there since 2.3.20 (!), see
http://www.tm.kernel.org/pub/linux/kernel/v2.3/patch-html/patch-2.3.20/linux_arch_i386_kernel_traps.c.html
Googling around I found this thread:
http://www.gossamer-threads.com/lists/linux/kernel/140216
HTH!
Cheers

P
