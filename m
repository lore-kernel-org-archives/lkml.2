Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0HQKD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:03:28 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:32964 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856Ab0HQKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:03:26 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-08.arcor-online.net 560E420549E
Message-Id: <E1OlJ0p-0001Cu-Jh@be1.7eggert.dyndns.org>
From: Bodo Eggert <7eggert@web.de>
Subject: Re: unable to mount a CD - iso9660 bug?
To: Ondrej Zary <linux@rainbow-software.org>, linux-fsdevel@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Johannes Stezenbach <js@sig21.net>
Reply-To: 7eggert@gmx.de
Date: Tue, 17 Aug 2010 12:03:19 +0200
References: <fi78T-3mn-25@gated-at.bofh.it> <fi8y0-60P-37@gated-at.bofh.it> <fi8HD-6ey-7@gated-at.bofh.it> <fibcu-1Ty-21@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary <linux@rainbow-software.org> wrote:
>> > On Mon, Aug 16, 2010 at 02:38:54PM +0200, Ondrej Zary wrote:

>> > > I have a CD that came with Samsung printer that Linux cannot mount but
>> > > works fine in Windows. The CD is physically OK - "dd" made ISO image
>> > > without any problems. This ISO image is unmountable too. When I force
>> > > the filesystem to iso9660, it mounts but no files are visible:

> Here's the compressed ISO file if anyone wants to examine it:
> http://www.rainbow-software.org/linux_files/samsung-bad.rar

If you use -onorock, the files are visible.

