Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1BHNCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:02:22 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53841 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1BHNCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:02:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CDRBw5QV/dZPKFR5gpO0l9HDMLD8lmKV5JVVVjMnBWtXDpNP4svWsz1B1xMRTFc7Ku
         Ienl4Rafaf5ro1QGdYVUcX7aQw83vZrCjVkeRsuNxO7NdJ7wUxEySGMarqcAzCTRrQbi
         4k6+3rQ/ApoB7VUu9EZyG21KZVMTNTF7J2FB8=
MIME-Version: 1.0
In-Reply-To: <20110208130416.675181fe@lxorguk.ukuu.org.uk>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122337.19110.8889.sendpatchset@linux-mhg7.site>
	<20110208130416.675181fe@lxorguk.ukuu.org.uk>
Date: Tue, 8 Feb 2011 14:02:20 +0100
Message-ID: <AANLkTik3vgGpj6cNWysT3dZfkaW9y-apck1P6Ywzy25n@mail.gmail.com>
Subject: Re: [PATCH 01/20] ata_piix: SITRE handling fix
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 2:04 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 08 Feb 2011 13:23:37 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>
>> >From 7b6d27a9d65fef8795fdeee3733316450f840aa6 Mon Sep 17 00:00:00 2001
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Tue, 8 Feb 2011 12:39:24 +0100
>> Subject: [PATCH 01/20] ata_piix: SITRE handling fix
>>
>> Set SITRE bit also in master-only configurations.
>
> Why ?

Mainly to match other PIIX-alike drivers and make further changes easier..
