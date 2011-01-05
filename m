Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1AEKZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:25:25 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52345 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1AEKZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:25:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
Date: Wed, 5 Jan 2011 11:26:03 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, aospan@netup.ru
References: <201012310726.31851.liplianin@netup.ru> <4D1DC2DD.6050400@infradead.org> <8739pec7bm.fsf@gmail.com>
In-Reply-To: <8739pec7bm.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101051126.04180.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 31 December 2010 16:04:13 Ben Gamari wrote:
> On Fri, 31 Dec 2010 09:47:41 -0200, Mauro Carvalho Chehab wrote:
> > > I understand this. However, a complete JTAG state machine in the
> > > kernel, plus an Altera firmware parser, seems to be a lot of code that
> > > could live in userspace.
> > 
> > Moving it to userspace would mean a kernel driver that would depend on an
> > userspace daemon^Wfirmware loader to work. I would NAK such designs.
> 
> Why? I agree that JTAG is a lot to place in the kernel and is much
> better suited to be in user space. What exactly is your objection to
> depending on a userspace utility? There is no shortage of precedent for
> loading firmware in userspace (e.g. fx2 usb devices).

I agree with this. Mauro, why would a userspace firmware loader be such a bad 
idea ?

> > > If I understand it correctly the driver assumes the firmware is in an
> > > Altera proprietary format. If we really want JTAG code in the kernel
> > > we should at least split the file parser and the TAP access code.
> > 
> > Agreed, but I don't think this would be a good reason to block the code
> > merge for .38.
> 
> I agree with the above isn't good reason to block it but if there is
> still debate about the general architecture of the code (see above),
> then it seems aren't ready yet. The code looks very nice, but I'm not at
> all convinced that it needs to be in the kernel. Just my two-tenths of a
> cent.

-- 
Regards,

Laurent Pinchart
