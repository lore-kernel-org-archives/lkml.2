Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079Ab2FVKfC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:35:02 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60847 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762021Ab2FVKfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAFub=KSth0q6VJ+adQmvXVjcVT0-XuyRzfN00+U9DWEHPi-aVw@mail.gmail.com>
References: <CAFub=KRdM2Mc1RXa_HfYO8gSxpyCpsP9Z1YHRULCLwNDnXQyEg@mail.gmail.com>
	<20120622094702.GD14083@ZenIV.linux.org.uk>
	<CAFub=KSth0q6VJ+adQmvXVjcVT0-XuyRzfN00+U9DWEHPi-aVw@mail.gmail.com>
Date: Fri, 22 Jun 2012 13:34:59 +0300
Message-ID: <CAFub=KR88Gtt-HkboOFKYK0O8_5uy6B5E2nkAK6dsi=-3ooi5w@mail.gmail.com>
Subject: Re: get_unused_fd and get_unused_fd_flags
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe I should backport alloc_fd and rename it to sth like
> compat_alloc_fd and use that instead of alloc_fd in compat. What I was
> trying to understand was the reason behind exporting/not-exporting
> those similar wrappers. I don't try to justify that it should be
> exported for me :)

Well this already seems unbackportable as alloc_fd() pulls in
expand_files() which pulls in expand_fdtable() which pulls in
alloc_fdtable(), etc. etc.


-- 
Ozan Çağlayan
