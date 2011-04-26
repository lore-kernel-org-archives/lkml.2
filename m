Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab1DZH7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:59:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40613 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1DZH7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cYU6ObJdhgJrIOONoE5/Xa+dbOIxyRF9sKl+r3Sc86eNGnc4c/6tHp2KQIlIZrQy2m
         3DfQxwESTbmqUuhoWedtsx8XarU5sTuy4800RyhVSfjtLsxdn9WboE9x2hgTSzSKTFWk
         95TSsQrQqY/dLe59s57IoPXPRB28w/PxS9TsQ=
MIME-Version: 1.0
In-Reply-To: <1303073786.31723.14.camel@Joe-Laptop>
References: <cover.1302907496.git.joe@perches.com>
	<440aa7f6bb99bec705b83796894f843bfc1b7bf9.1302907497.git.joe@perches.com>
	<BANLkTikeV-jHXWSDyLmtTTc1d2S9L3eG0Q@mail.gmail.com>
	<1303073786.31723.14.camel@Joe-Laptop>
Date: Tue, 26 Apr 2011 10:59:14 +0300
Message-ID: <BANLkTimsuTYRn0+_Ap+W_a9d6X=zFgngfQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] ata: Add and use ata_print_version_once
From: saeed bishara <saeed.bishara@gmail.com>
To: Joe Perches <joe@perches.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 11:56 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2011-04-17 at 13:45 +0300, saeed bishara wrote:
>> On Sat, Apr 16, 2011 at 1:52 AM, Joe Perches <joe@perches.com> wrote:
>> > Use a single mechanism to show driver version.
>> > Reduces text a tiny bit too.
>> > Remove uses of static int printed_version
>> > Add and use ata_print_version(const struct device *, const char *ver)
>> > and ata_print_version_once.
>> any idea why we really need this driver version for in-kernel drivers?
>> isn't the kernel version good enough?
>
> Some think it useful to see what module
> version is linked against the kernel.
1. I looked at 3-4 drivers, and found that it didn't modified its
version since at least 3 years, so it doesn't look to me that this
version is maintained properly.
2. anyway, if you still think this feature is needed, then maybe you
should consider making it generic one, this is not ata specific
feature.
saeed
