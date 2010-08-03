Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0HCLCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:02:48 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55863 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab0HCLCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:02:46 -0400
Date: Tue, 3 Aug 2010 13:02:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Am?rico Wang <xiyou.wangcong@gmail.com>, hacklu <embedway.linux@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how about KBUILD_MODNAME
Message-ID: <20100803110245.GA19571@merkur.ravnborg.org>
References: <201008031037022524247@gmail.com> <201008031511572638256@gmail.com> <4C57E6F9.6080104@panasas.com> <4C57E7EB.4090904@gmail.com> <20100803101544.GJ5129@cr0.nay.redhat.com> <4C57EE69.4080209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C57EE69.4080209@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 01:24:41PM +0300, Boaz Harrosh wrote:
> On 08/03/2010 01:15 PM, Américo Wang wrote:
> > 
> > And it doesn't make sense to hold two drivers in one .c file.
> > 
> 
> I meant when two drivers share the same .c file. But instead of
> using a third common module they just share it by duplicating
> the code. example:
> 
> <Kbuild>
> drv1-y := drv-one.o common.o
> obj-$(CONFIG_DRV1) += drv1.o
> 
> drv2-y := drv-two.o common.o
> obj-$(CONFIG_DRV2) += drv2.o
> </Kbuild>
> 
> When compiling common.o the KBUILD_MODNAME fails to be set

Correct - but I do not think this is relavent in this case.
The code snippet shown clearly indicates that the drivers
uses a 2.4 style Makefile. This will not work with 2.6.

	Sam
