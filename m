Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1DNQcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:32:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60006 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1DNQcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=q7WzOjrxOx6qduEbloro6oBweyaTMm8zB4Lp2h+taaquExUnfbSB6JiPscx9OUbz2j
         TuDyYELGWBdPa9jRQMWXiI4i2cSW//b3ylmxPaeyLw7bl3ukGq59uNim5fr2B5A7BO0Y
         sLXcWQ2gUE+UvTR3FFWA+GlBQ07lwBiZLsuf0=
MIME-Version: 1.0
In-Reply-To: <20110414161003.7EAF03A6140@erode.bofh.it>
References: <gxpEm-2oj-27@gated-at.bofh.it>
	<gyaad-5vV-17@gated-at.bofh.it>
	<dd879ace-5171-4345-8c0b-bc5168a48cbd@f15g2000pro.googlegroups.com>
	<20110414161003.7EAF03A6140@erode.bofh.it>
Date: Thu, 14 Apr 2011 19:32:41 +0300
Message-ID: <BANLkTimcjTepvn07KB8qDCQJrKqc=JA=vA@mail.gmail.com>
Subject: Re: x86: Cleanup highmap after brk is concluded
From: Yuri Arabadji <yuri.arabadji@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I strongly disagree with this commit. Some freak back-ported it into
2.3.32 and since then fear and suffering was brought to many innocent
people. It took me straight 3 hours of bisecting & testing to find out
why latest "stable" "longterm" 2.6.32 kernel (used as Xen PVops) won't
even boot on latest CentOS' standard dom0.

Something's wrong up there in the heavens. Can we get a working kernel
on kernel.org, please, and more testing/reviewing in the future?

Thanks.

On Mar 19, 10:40 pm, tip-bot for Yinghai Lu <ying...@kernel.org> wrote:
> Commit-ID:  e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e
> Gitweb:    http://git.kernel.org/tip/e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e
> Author:     Yinghai Lu <ying...@kernel.org>
> AuthorDate: Fri, 18 Feb 2011 11:30:30 +0000
> Committer:  H. Peter Anvin <h...@zytor.com>
> CommitDate: Sat, 19 Mar 2011 11:58:19 -0700
>
> x86: Cleanup highmap after brk is concluded
>
