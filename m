Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1GaBGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:06:54 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57362 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1GaBGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:06:47 -0400
MIME-Version: 1.0
In-Reply-To: <4E34A1E4.8040103@zytor.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
	<CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	<4E34998D.8060806@zytor.com>
	<CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	<4E34A1E4.8040103@zytor.com>
Date: Sat, 30 Jul 2011 21:06:46 -0400
Message-ID: <CACqU3MVkLXoBq7KP2Jff=p7EiKR7DkPa4z7y0Rdah-dGzRvj4g@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Added Roman Zippel to the Cc: list.]

On Sat, Jul 30, 2011 at 8:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/30/2011 05:05 PM, Arnaud Lacombe wrote:
>>>
>>> Why????
>>>
>> Because kconfig might not be ran exclusively from a fully controlled
>> and restricted environment ? Not to mention that it is used by other
>> people than the linux kernel folks.
>>
>
> I'm sorry, but whitelisting specific options is an absolutely idiotic
> way to deal with that.
I'm sure the author of `option env=""' will appreciate that. I'd be
interested to know if there was a reason to do it that way rather than
allow the environment to override all symbols.

> The options use a specific namespace (CONFIG_*),
CONFIG_ is sure very specific namespace...

> and only allowing some options to be set on the command line, but not
> others, is a serious violation of the principle of least surprise.
>
The principle of least surprise is broken anyway as the proposed patch
has absolutely no dependency checking and verification. You can `make
CONFIG_SATA_MV=y allnoconfig', you will _not_ get it set.

 - Arnaud

>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>
