Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1A0CCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 21:02:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33118 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab1A0CCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 21:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AqhTi8twRcS138OpSY6OsNuOJM1FQfHz63tUBzRaTHyqIDPrrP2wH96lmoryyXfLRR
         cXs1zJ/w4FQ11PZGK+FECYiXP/L8Iv2k907i/4vcUrodWSh3VlKaN29dx20crkDPiDjD
         I/13DKP7KB4m0VwFQNLzHD/V+Ft79nHfC//zw=
MIME-Version: 1.0
In-Reply-To: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
Date: Thu, 27 Jan 2011 10:02:43 +0800
Message-ID: <AANLkTikq2YttapeLKkSeM-MrPoBdvPR32-oL6BdBOKdf@mail.gmail.com>
Subject: Re: [PATCH 0/6] use BUG_ON correctly
From: Yong Zhang <yong.zhang0@gmail.com>
To: Coly Li <bosong.ly@taobao.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 2:39 AM, Coly Li <bosong.ly@taobao.com> wrote:
> BUG_ON() already uses unlikely() inside its definition if possible,

It's true for asm-generic/bug.h.

But for archs which has defined HAVE_ARCH_BUG,
unlikely() is not always included in it.

Thanks,
Yong

-- 
Only stand for myself
