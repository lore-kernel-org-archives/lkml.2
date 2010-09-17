Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0IQQ7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:59:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63723 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0IQQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:59:41 -0400
MIME-Version: 1.0
In-Reply-To: <20100917160554.GB14186@core.coreip.homeip.net>
References: <1282222699.1236.21.camel@yio.site> <AANLkTikpCt-RjK87qb0cwdu_uUSfR-Dn_0d5PYhETM5T@mail.gmail.com>
 <20100917160554.GB14186@core.coreip.homeip.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 17 Sep 2010 18:59:24 +0200
Message-ID: <AANLkTinFjnt7zm3YmOAASR6YEn+6CSWcbNV3R4=scnSh@mail.gmail.com>
Subject: Re: [PATCH] uinput: add devname alias to allow module on-demand load
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 18:05, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Sep 17, 2010 at 11:53:43AM +0200, Kay Sievers wrote:
>> On Thu, Aug 19, 2010 at 14:58, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> > From: Kay Sievers <kay.sievers@vrfy.org>
>> > Subject: uinput: add devname alias to allow module on-demand load
>> >
>> > Recent modprobe and udev versions allow to create device nodes
>> > for modules which are not loaded. Only the first access will cause
>> > the in-kernel module loader to pull-in the module. Systems which
>> > never access the device node will not needlessly load the module,
>> > and no longer need init scripts or other facilities to unconditionally
>> > load it.
>>
>> Dmitry?

> [dtor@hammer work]$ git describe --contains 8905aaafb4b5d9764c5b4b54c7d03eb41bb0a7e9
> v2.6.36-rc3~19^2~2

Awesome!
So much for stupidly waiting-for-reply instead of just checking the reality. :)

Thanks,
Kay
