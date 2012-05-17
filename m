Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094Ab2EQPXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:23:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760746Ab2EQPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:23:35 -0400
MIME-Version: 1.0
In-Reply-To: <1337266969-19181-1-git-send-email-levinsasha928@gmail.com>
References: <1337266969-19181-1-git-send-email-levinsasha928@gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 17 May 2012 17:23:14 +0200
Message-ID: <CAPXgP12fMp6+1UquRapLUP9+Ap0XPWnbChZvEEvcP54njCngZg@mail.gmail.com>
Subject: Re: [RFC] printk: add relative printk timing support
To: Sasha Levin <levinsasha928@gmail.com>
Cc: greg@kroah.com, torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, hpa@kernel.org,
        yinghai@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 5:02 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> This patch adds support for relative timestamps in printk output.


> Next, with Linus' suggestion (Month and date, no seconds):
>
> [May 17 14:13] foo

Any idea how to handle suspend cycles right? The wall clock time
translation might not be correct anymore, or is that covered?

Also, we currently record local CPU times, they are only guaranteed to
be monotonic for the same CPU, not across them. So we could see
negative offsets?

Kay
