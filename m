Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1DBFMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 01:12:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60120 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1DBFMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 01:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PXHBmIGBAkgRErUvfHC1QvsUXcbHwhMNdcIqRopdn3Oevj+vQ7FmxGrxZep1kWCA5y
         0v+XWUi1ac9vNMBVHbPwH6MQEQ99BOptIZUvQ7yayzkavTE2yZRGQUD4vf2aH4J4rD72
         IWQH7s0NiJizOcusIgnBxvRpOhxd1HBMg9Zc8=
MIME-Version: 1.0
In-Reply-To: <1301667827-20056-6-git-send-email-julia@diku.dk>
References: <1301667827-20056-6-git-send-email-julia@diku.dk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 2 Apr 2011 01:05:57 -0400
Message-ID: <BANLkTinF-Z_1J8UiPJ0wnaDLxgHRv0MsPw@mail.gmail.com>
Subject: Re: [PATCH 6/6] drivers/video/bfin-lq035q1-fb.c: introduce missing kfree
To: Julia Lawall <julia@diku.dk>
Cc: Paul Mundt <lethal@linux-sh.org>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 10:23, Julia Lawall wrote:
> Error handling code following a kmalloc should free the allocated data.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
