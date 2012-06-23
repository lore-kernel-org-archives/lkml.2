Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2FWIBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 04:01:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56322 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2FWIBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 04:01:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_1RduD=yh0vjVdb3RwQn9ivxcBEGgJ3aTXuGgj4=FEznYmXg@mail.gmail.com>
References: <CAN_1RdvqJRig8vZW_gcvNVKYNo7ROmEKxAs7qu1N6XE4+Pspjg@mail.gmail.com>
	<20120623040633.GA16278@kroah.com>
	<CAN_1RdtfiWtuqV=vBkagZfmvstket499QdCK3zZrrS8xKTZwPA@mail.gmail.com>
	<20120623044105.GA32663@kroah.com>
	<CAN_1RduD=yh0vjVdb3RwQn9ivxcBEGgJ3aTXuGgj4=FEznYmXg@mail.gmail.com>
Date: Sat, 23 Jun 2012 16:01:15 +0800
Message-ID: <CAM_iQpVyJq2BzQ6anviJrWcRqNAP1EU-ngCMA267utc2B2soVQ@mail.gmail.com>
Subject: Re: [PATCH] Implement uhook(call kernel func from userspace) driver
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Peiyong Feng <peiyong.feng.kernel@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 2:01 PM, Peiyong Feng
<peiyong.feng.kernel@gmail.com> wrote:
>
> I mean that although the main line kernel cannot accept this patch, and
> uhook is very useful to play a rule as a debug tool.

It depends, we already have kprobe, tracepoint, kgdb, kdump...

> Is there some where else
> that can hold this tool, and let more people use the uhook?

You have github, don't you?
