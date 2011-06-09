Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab1FILD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:03:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40640 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab1FILD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:03:58 -0400
MIME-Version: 1.0
In-Reply-To: <1307548205.27558.3.camel@Joe-Laptop>
References: <20110608104057.GA11680@ahead>
	<20110608082548.8ab682fd.rdunlap@xenotime.net>
	<1307548205.27558.3.camel@Joe-Laptop>
Date: Thu, 9 Jun 2011 12:03:58 +0100
Message-ID: <BANLkTimPcp8WiJwzUT0feBYDky8JRSx=Kg@mail.gmail.com>
Subject: Re: doc?
From: Andrew Murray <amurray@mpcdata.com>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, wangyanqing <udknight@gmail.com>,
        namhyung@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

I have this and will post it tonight. Thanks for the prod.

Thanks,

Andrew Murray

On 8 June 2011 16:50, Joe Perches <joe@perches.com> wrote:
>
> On Wed, 2011-06-08 at 08:25 -0700, Randy Dunlap wrote:
> > On Wed, 8 Jun 2011 10:40:58 +0000 wangyanqing wrote:
> > > I can't find the information
> > > from Documentation/printk-formats.txt.
> > It wouldn't hurt to add some docs, yes, but for now the %p
> > extensions are all documented in lib/vsprintf.c, just above
> > function pointer(), around line 802 in 3.0-rc2.
>
> Awhile back Andrew Murray proposed a patch.
> Maybe he'll get back to it.
>
> https://lkml.org/lkml/2011/2/5/212
>
>



--
Andrew Murray, Embedded Linux Group
MPC Data Limited
e-mail: amurray@mpc-data.co.uk  web: www.mpc-data.co.uk
tel: +44 (0) 1225 710600               fax: +44 (0) 1225 710601
ddi: +44 (0) 1225 710665

MPC Data Limited is a company registered in England and Wales with
company number 05507446
Registered Address: County Gate, County Way, Trowbridge, Wiltshire, BA14 7FJ
VAT no: 850625238

The information in this email and in the attached documents is
confidential and may be
legally privileged. Any unauthorized review, copying, disclosure or
distribution is
prohibited and may be unlawful. It is intended solely for the
addressee. Access to this
email by anyone else is unauthorized. If you are not the intended
recipient, please
contact the sender by reply email and destroy all copies of the
original message. When
addressed to our clients any opinions or advice contained in this
email is subject to
the terms and conditions expressed in the governing contract.
