Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0KJCLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:11:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44670 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KJCLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:11:18 -0500
MIME-Version: 1.0
In-Reply-To: <1289353544.22787.49.camel@concordia>
References: <1289339119.2191.92.camel@laptop> <20101109221338.GA19947@suse.de>
 <1289345811.10536.8.camel@concordia> <AANLkTi=UftgQn0ydRd2wszqFtpRrkEcW7dzfapKKix_V@mail.gmail.com>
 <1289350360.22787.9.camel@concordia> <AANLkTikGHNkUN6t9rPhdE6XOQiqb5xAzH_9eY6L9h2H2@mail.gmail.com>
 <1289351423.22787.22.camel@concordia> <AANLkTin_VixECn4AdQW_xC=_5ZNY5wBsif6cW5dDEJFe@mail.gmail.com>
 <1289353544.22787.49.camel@concordia>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 10 Nov 2010 03:11:01 +0100
Message-ID: <AANLkTinTwphGkvuzQPaf41j_g=_cJC8TX9es8s+NeucE@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
To: michael@ellerman.id.au
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:45, Michael Ellerman <michael@ellerman.id.au> wrote:
> On Wed, 2010-11-10 at 02:19 +0100, Kay Sievers wrote:

>> >> The pseudo-convenience device_register/device_unregister should also
>> >> not be used.
>> >
>> > Why are they in the tree if they shouldn't be used?
>>
>> Because they save one line and do improper error handling.
>> They should all be converted to device_init+device_add/device_del/device_put.
>
> I don't see device_init(), or do you mean device_initialize()? It
> returns void?

http://lkml.org/lkml/2010/9/22/56

Kay
