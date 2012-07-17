Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2GQGtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:49:52 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2447 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2GQGtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:49:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: Tree for July 12 (v4l2-ioctl.c)
Date: Tue, 17 Jul 2012 08:48:37 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc7-tschai; KDE/4.8.4; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-media" <linux-media@vger.kernel.org>
References: <20120712160335.9cbff13c2f18eadc7d3cb0cf@canb.auug.org.au> <4FFEF21A.7050701@xenotime.net> <CACVXFVOy7VGstdotnofq=o_UmFh0KwqH6p25MamwAbLfRgcTRg@mail.gmail.com>
In-Reply-To: <CACVXFVOy7VGstdotnofq=o_UmFh0KwqH6p25MamwAbLfRgcTRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207170848.37945.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 17 2012 04:25:35 Ming Lei wrote:
> On Thu, Jul 12, 2012 at 11:49 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On 07/11/2012 11:03 PM, Stephen Rothwell wrote:
> >
> >> Hi all,
> >>
> >> Changes since 20120710:
> >
> >
> >
> > on i386 and/or x86_64, drivers/media/video/v4l2-ioctl.c has too many
> > errors to be listed here.  This is the beginning few lines of the errors:
> 
> I see the errors on ARM too.

A fix can be found here:

http://patchwork.linuxtv.org/patch/13336/

Regards,

	Hans
