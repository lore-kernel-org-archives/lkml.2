Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1IMRy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:54:57 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:34862 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1IMRy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <201109131733.59700.arnd@arndb.de>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
 <6360771.ouEC5EKNMR@wuerfel> <1315917546.11280.38.camel@deneb.redhat.com> <201109131733.59700.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 13 Sep 2011 11:54:36 -0600
X-Google-Sender-Auth: ZnZ_Z_w2JJa4JQJ7Ea7mZKOPZG0
Message-ID: <CACxGe6tVafwVN6vdU7sCxL5JM7+as0bp_AaHaGAyE9+eTgR5Tw@mail.gmail.com>
Subject: Re: [PATCH 06/24] C6X: devicetree
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Salter <msalter@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 9:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 13 September 2011, Mark Salter wrote:
>> On Tue, 2011-09-13 at 08:43 +0200, Arnd Bergmann wrote:
>> > Are these instructions specific to the interrupt controller or
>> > do they access a register space that can contain arbitrary
>> > devices?
>> >
>> > If there is a separate address space for special devices, it might
>> > be good to describe that in the device tree, like we do for PCI
>> > I/O space.
>> >
>>
>> It is a core register area. Similar to ARM or MIPS coprocessor
>> registers.
>
> I guess it still depends, it's probably a grey area. If the register layout
> is the same on all c6x cores and it's only for core stuff, there is no need
> to put it in the device tree. If you have multiple soc (off-core) devices
> being controlled through the registers, or the numbers vary a lot between
> different chips, I would put all of them into the device tree.

It's an interrupt controller.  There still needs to be a node to act
as the interrupt-parent and specify #interrupt-cells.

g.
