Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab2CUQN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:13:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43204 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab2CUQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120321153317.GA30250@kroah.com>
References: <CAN628AFKSgd2nKY5Ga7JqhVWqAySRW8OpeLyykOwocn4K_a-qQ@mail.gmail.com>
	<20120321153317.GA30250@kroah.com>
Date: Thu, 22 Mar 2012 00:13:26 +0800
Message-ID: <CACwZE5RbGARjgNRuJuLquDY_THjspH20JMEbKqsZVwj4jJtFhw@mail.gmail.com>
Subject: Re: [PATCH] VMUFAT filesystem [1/4]
From: Adrian McMenamin <adrianmcmenamin@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, viro@zeniv.linux.org.uk,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2012 23:33, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 21, 2012 at 12:30:36PM +0800, Adrian McMenamin wrote:
>> >From d587b09573c06309bb2c3ef12223b77fffc3a922 Mon Sep 17 00:00:00 2001
>> From: Adrian McMenamin <adrianmcmenamin@gmail.com>
>> Date: Wed, 21 Mar 2012 12:17:51 +0800
>> Subject: [PATCH] Add vmufat filesystem
>>
>> ---
>
> Hint, read Documentation/SubmittingPatches for how to properly create
> patches that could be applied, if they were in mergable state (you
> forgot the changelog entry, signed-off-by line, and probably a few other
> things...)
>

In fact a changelog and a signed-off-by line are in the email marked
1/4 - which plainly made it to the lkml even if some subscribers would
appear not to have seen it: https://lkml.org/lkml/2012/3/21/10
