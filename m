Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0FTP6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 11:58:50 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42625 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0FTP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 11:58:49 -0400
References: <1277018446.1548.66.camel@Joe-Laptop.home>
Message-Id: <16004456-69D9-41BD-8597-5590BB7B099E@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Joe Perches <joe@perches.com>
In-Reply-To: <1277018446.1548.66.camel@Joe-Laptop.home>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7E18)
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: [PATCH] drivers/media/IR/imon.c: Use pr_err instead of err
Date: Sun, 20 Jun 2010 11:58:41 -0400
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media <linux-media@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2010, at 3:20 AM, Joe Perches <joe@perches.com> wrote:

> Use the standard error logging mechanisms.
> Add #define pr_fmt(fmt) KBUILD_MODNAME ":%s" fmt, __func__
> Remove __func__ from err calls, add '\n', rename to pr_err
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Eh. If we're going to make a change here, I'd rather it be to using  
dev_err instead, since most of the other spew in this driver uses  
similar.

-- 
Jarod Wilson
jarod@wilsonet.com

