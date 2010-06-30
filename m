Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0F3HeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:34:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56216 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab0F3HeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:34:02 -0400
MIME-Version: 1.0
X-Originating-IP: [134.134.137.73]
In-Reply-To: <AANLkTik2IbCti-nlCkNwYQShnMXXsXhxuQJUV4eSColf@mail.gmail.com>
References: <AANLkTinrDVKmA4Jcr-JimhMKogjVzdLsbsB5beWJSVla@mail.gmail.com>
	<AANLkTik2IbCti-nlCkNwYQShnMXXsXhxuQJUV4eSColf@mail.gmail.com>
Date: Wed, 30 Jun 2010 15:34:01 +0800
Message-ID: <AANLkTilZPgvICbrolTRnG_w-w7EXr1BRxENznqTGaWWh@mail.gmail.com>
Subject: Re: How to find a lost git commit?
From: Lin Ming <lin@ming.vg>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 3:31 PM, Po-Yu Chuang <ratbert.chuang@gmail.com> wrote:
> Hi Lin,
>
> 2010/6/30 Lin Ming <lin@ming.vg>:
>> I wrote some patch and checked it in my local branch.
>> But by accident, I run "git reset --hard" to reset the git head to
>> some other commit.
>>
>> So now I can't find my patch because I don't know it's commit number.
> I guess git reflog is what you need.

Wow! That's it!

Many thanks.
