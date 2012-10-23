Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156Ab2JWXka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:40:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40660 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2JWXk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:40:29 -0400
MIME-Version: 1.0
In-Reply-To: <20121023233356.GY21164@n2100.arm.linux.org.uk>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-8-git-send-email-keescook@chromium.org>
	<20121023233356.GY21164@n2100.arm.linux.org.uk>
Date: Tue, 23 Oct 2012 16:40:28 -0700
X-Google-Sender-Auth: Us4LItD2wkVCW7UKSWZvVBRLQV8
Message-ID: <CAGXu5jJiLyJ0DonP1bGdetgEFAk83jix9jKj+YXKvVyEVH8p+Q@mail.gmail.com>
Subject: Re: [PATCH 007/193] arch/arm: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 4:33 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Oct 23, 2012 at 01:01:20PM -0700, Kees Cook wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, remove it.
>
> I have a patch queued up for -rc which removes a number of these, but
> specifically leaves some which do cause people problems.  So I'd
> appreciate it if we kept some of these (EXPERIMENTAL) tags even if we
> do drop the dependency.

Okay, I'll switch it around to only drop the "depends on ..."

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
