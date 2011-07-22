Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956Ab1GVESS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 00:18:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49942 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1GVESR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 00:18:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110721143709.0c1e66d6.akpm@linux-foundation.org>
References: <1310951766-3840-1-git-send-email-akinobu.mita@gmail.com>
	<20110721143709.0c1e66d6.akpm@linux-foundation.org>
Date: Fri, 22 Jul 2011 12:18:16 +0800
Message-ID: <CAM_iQpXW-Vb60gtA6ATn5J9XZmTvXow8ccD_BzD8JqQe4BTQaw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] notifier error injection
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 5:37 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
...
> Such a script would logically reside under ./tests/fault-injection/,
> but we still don't have a tests/ directory.  Which perhaps tells us
> something ;)

We have tools/testing/. :)
