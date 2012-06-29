Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2F2O7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:59:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64396 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2F2O7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <1340981670.6562.25.camel@joe2Laptop>
References: <1340979104-19377-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<1340981670.6562.25.camel@joe2Laptop>
Date: Fri, 29 Jun 2012 17:59:12 +0300
Message-ID: <CAMXE1-rxShpXA4i04wG3_xoZdkBLWoVPKZLmxQGnuEAn8prDRQ@mail.gmail.com>
Subject: Re: [RFC] vsprintf: Add %pb[1-64] specifier to print hex memory dump
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 29, 2012 at 5:54 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2012-06-29 at 17:11 +0300, Andrei Emeltchenko wrote:
>> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>>
>> Add new specifier which may be used to print 1-64 bytes of memory.
>> There is often a need to print small (up to 64 bytes) objects like
>> bluetooth keys in debug purposes. Currently we have to create special
>> function for that.
>
> print_hex_dump() ?

If this only needed for debug we would need to undef this?

Regards,
Andrei
