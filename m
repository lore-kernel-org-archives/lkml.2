Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1GaAFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:05:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60594 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1GaAFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:05:31 -0400
MIME-Version: 1.0
In-Reply-To: <4E34998D.8060806@zytor.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
	<CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	<4E34998D.8060806@zytor.com>
Date: Sat, 30 Jul 2011 20:05:30 -0400
Message-ID: <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 30, 2011 at 7:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/30/2011 04:44 PM, Arnaud Lacombe wrote:
>>
>> Beside that, the one thing I dislike with your patch is that it is
>> unconditional and global to all symbols, and you have no way to forbid
>> the environment to override a value.
>>
>
> Why????
>
Because kconfig might not be ran exclusively from a fully controlled
and restricted environment ? Not to mention that it is used by other
people than the linux kernel folks.

 - Arnaud
