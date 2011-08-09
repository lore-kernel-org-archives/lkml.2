Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HIP0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:26:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60127 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1HIP0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:26:51 -0400
MIME-Version: 1.0
In-Reply-To: <4E4140B3.7090802@suse.cz>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
	<CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	<4E34998D.8060806@zytor.com>
	<CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	<4E4140B3.7090802@suse.cz>
Date: Tue, 9 Aug 2011 11:26:50 -0400
Message-ID: <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 9, 2011 at 10:14 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 31.7.2011 02:05, Arnaud Lacombe wrote:
>>
>> Hi,
>>
>> On Sat, Jul 30, 2011 at 7:53 PM, H. Peter Anvin<hpa@zytor.com>  wrote:
>>>
>>> On 07/30/2011 04:44 PM, Arnaud Lacombe wrote:
>>>>
>>>> Beside that, the one thing I dislike with your patch is that it is
>>>> unconditional and global to all symbols, and you have no way to forbid
>>>> the environment to override a value.
>>>>
>>>
>>> Why????
>>>
>> Because kconfig might not be ran exclusively from a fully controlled
>> and restricted environment ? Not to mention that it is used by other
>> people than the linux kernel folks.
>
> Well, it has always been possible to trick kbuild (not kconfig) into
> accepting CONFIG_* options from environment, because unset kconfig options
> in auto.conf are not seen by make. Of course this is completely fragile,
> because there is no dependency checking and such variables are only seen by
> make and do not appear in autoconf.h. So a patch that teaches kconfig to
> read options from the environment would actually make some (albeit currently
> "illegal") use cases work correctly :).
>
kconfig can already set symbol value from the environment. The only
limitation I can see is that it is not optional and require an
explicit environment variable name.

 - Arnaud
