Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915Ab1GNEDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 00:03:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32920 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1GNEDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 00:03:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110713151724.3b16ce77.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
	<CACqU3MWBb4J8rmaRv23=-_=GXppGSUdqmOqeXoqWi4ZJ7ZYewg@mail.gmail.com>
	<20110713150023.0dde9ef4.rdunlap@xenotime.net>
	<CACqU3MVh+4JMX5ywPgWrrXXuAcAYtHJyumXGDcteageJAG12wA@mail.gmail.com>
	<20110713150840.2fa8e2b3.rdunlap@xenotime.net>
	<CACqU3MXSwJG14PwD0c6R7VZg9fO=XLj=-QDN5ntbQp+0xDn82A@mail.gmail.com>
	<20110713151724.3b16ce77.rdunlap@xenotime.net>
Date: Thu, 14 Jul 2011 00:03:21 -0400
Message-ID: <CACqU3MXabT0+yx8UdFXQ14-CzQTJyMYjEdxWtAgC94rSCJWbFQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] stringify: add HEX_STRING()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 13, 2011 at 6:17 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> [...]
>> > Sure, go for it.  I'll ack it.  ;)  [or Review it :]
>> > and test it.
>> >
>> it is already among the hunks in https://patchwork.kernel.org/patch/380601/
>
> I realize that, but it looks like you may need to resubmit it.
>
I have an updated set of patches against -next, I still need to break
them down by tree. As a lots of things I did today went completely
south, I guess it would be better if I do this task early tomorrow :-)

 - Arnaud
