Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab1DQKpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 06:45:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38907 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab1DQKpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 06:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cLP3kvQsOZhNwdHe9OOH69lNkMGJcYj6911M7VeHvujcIGIYPuk238uuPhaWvulgpE
         5ETNAGekK9sGfBrkC1IlQQ0M3uaWHxJS37Hpg6M+NI8nAQqBcaSlClsmTebi71c3C2++
         mHrLqemunnNVsRQhrJnaJYvrWWcOWJPXVRVIY=
MIME-Version: 1.0
In-Reply-To: <440aa7f6bb99bec705b83796894f843bfc1b7bf9.1302907497.git.joe@perches.com>
References: <cover.1302907496.git.joe@perches.com>
	<440aa7f6bb99bec705b83796894f843bfc1b7bf9.1302907497.git.joe@perches.com>
Date: Sun, 17 Apr 2011 13:45:02 +0300
Message-ID: <BANLkTikeV-jHXWSDyLmtTTc1d2S9L3eG0Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] ata: Add and use ata_print_version_once
From: saeed bishara <saeed.bishara@gmail.com>
To: Joe Perches <joe@perches.com>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 1:52 AM, Joe Perches <joe@perches.com> wrote:
> Use a single mechanism to show driver version.
> Reduces text a tiny bit too.
>
> Remove uses of static int printed_version
> Add and use ata_print_version(const struct device *, const char *ver)
> and ata_print_version_once.
any idea why we really need this driver version for in-kernel drivers?
isn't the kernel version good enough?
saeed
