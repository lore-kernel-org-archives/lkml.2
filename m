Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2ALO4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:56:30 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58477 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2ALO41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:56:27 -0500
MIME-Version: 1.0
In-Reply-To: <document-depends-on-reason@mdm.bga.com>
References: <1326309371-10757-1-git-send-email-grant.likely@secretlab.ca> <document-depends-on-reason@mdm.bga.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 12 Jan 2012 07:56:06 -0700
X-Google-Sender-Auth: _1dSYybYO5a34CucIFftkQsA1OU
Message-ID: <CACxGe6vnE=11gnZPKvCvdLL-5hVABh1pdqfMJKxUcXHJiSvBVA@mail.gmail.com>
Subject: Re: [PATCH] gpio/it8761e: Restrict it8761e gpio driver to x86.
To: Milton Miller <miltonm@bga.com>
Cc: Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 2:22 AM, Milton Miller <miltonm@bga.com> wrote:
> On Wed Jan 11 2012 - 14:16:36 EST, Grant Likely wrote:
>> This driver does an unconditional read of io space during module init which
>> causes a bad dereference on ARM. It looks to me like this is an x86 only
>> drivers, so restrict it to only compile on x86.
>
>> config GPIO_IT8761E
>>          tristate "IT8761E GPIO support"
>> +        depends on X86
>>          help
>>            Say yes here to support GPIO functionality of IT8761E super I/O chip.
>
>
> Please add a comment to the Kconfig stanza with the reason for the
> dependancy so people don't have to be git blame masters to know why
> its there.
>
> Something like
>        depends on X86 # unconditional read of io space during module init

okay, will do.

g.
