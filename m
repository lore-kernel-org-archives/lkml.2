Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab1CXGvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:51:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64723 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab1CXGvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=fyWqVofxXbO+9f88A/9Cnko/+TubMTVVl4uTu3kyotIH26gIEdrUFIJYFNZNPBHZLz
         KBCKC8L+auo1e0JF1k89awPWR1tqGaY8fp4psWnnbFn6ipTvUXX5nvcjToytEouMHIxN
         w7zLdOr7liuWpyGyTaIYGZvDxrTJiWvSywyFc=
MIME-Version: 1.0
In-Reply-To: <1287598311.1813.225.camel@Joe-Laptop>
References: <1287598311.1813.225.camel@Joe-Laptop>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 02:51:14 -0400
X-Google-Sender-Auth: Dc0no30wb-UKzy33ozIrMtDq_nI
Message-ID: <AANLkTimANXLdtwfCK9yOHS9Zb_0=tgKQguBS-i9Nhfsg@mail.gmail.com>
Subject: Re: [PATCH] arch/blackfin/kernel/module.c: Use more standard pr_fmt
To: Joe Perches <joe@perches.com>
Cc: uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 14:11, Joe Perches wrote:
> Changed pr_fmt(fmt) to make the format arguments match the format.
> Changed an argument name in apply_relocate from me to mod
> so that the pr_err is consistent with the other uses.
> Added missing '\n' to a format.

thanks, merged
-mike
