Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1APSVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:21:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369Ab1APSVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:21:11 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimBXn8zoQdPE0t-P5FZ_rLi+1jzuzG+WxeiCwFD@mail.gmail.com>
References: <AANLkTimBXn8zoQdPE0t-P5FZ_rLi+1jzuzG+WxeiCwFD@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jan 2011 10:20:48 -0800
Message-ID: <AANLkTim6u9WUE7RkXUYEbTqftZ8gmB1xTYD_H8c7yhpu@mail.gmail.com>
Subject: Re: Please revert nouveau.
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 10:14 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>
> Attached dmesg for 2.6.37-git14
>
> Until they test some more and present that, please revert.

You need to describe the problem a lot more. Your dmesg doesn't even
contain anything about nouveau or dri messages at all (or in fact
anything that looks suspicious). So I think you really need to bisect
where the (undescribed) problem started.

                           Linus
