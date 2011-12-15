Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab1LOUEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 15:04:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1LOUEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 15:04:31 -0500
MIME-Version: 1.0
In-Reply-To: <20111215191523.GA2561@tuxdriver.com>
References: <20111215191523.GA2561@tuxdriver.com>
Date: Thu, 15 Dec 2011 21:04:29 +0100
Message-ID: <CACna6rw736JdkoM8zKxorCFd5oy08QTwWZ6PutoJPSr3ZN8hTg@mail.gmail.com>
Subject: Re: pull request: wireless 2011-12-15
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/15 John W. Linville <linville@tuxdriver.com>:
> commit 42a3b63bb2ca4996a3d1210a004eae2333f1119e
>
> Dave,
>
> Here are a few more fixes intended for the 3.2 release.  They are
> all small and narrowly focused.

John, I've made a mistake and didn't use [PATCH 3.2] header to make it
clean my patch is fix. Could you take a look at
[PATCH] bcma: support for suspend and resume
please?

It's not one-liner, but fixes lock ups, which I believe - we really
want to avoid.

-- 
Rafał
