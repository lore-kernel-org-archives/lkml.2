Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2DWNpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:45:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab2DWNpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:45:45 -0400
Date: Mon, 23 Apr 2012 15:45:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtitmuss@logitech.com, ogay@logitech.com, jzanone@logitech.com
Subject: Re: [PATCH v5 1/1] HID: Add full support for Logitech Unifying
 receivers
In-Reply-To: <CAN+gG=Hs-JrnPvfAB2XtrSQiKYw4NFMOKBaj+8n9Xtoq1rmtUA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1204231544220.1856@pobox.suse.cz>
References: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com> <4E77A221.1060909@t-online.de> <CAN+gG=EcaMrz2w-cVL-cCwi2NNVJ-NXOpOQpbjyFdCwn5+Bn+w@mail.gmail.com> <alpine.LRH.2.00.1204171027220.11298@twin.jikos.cz>
 <CAN+gG=Hs-JrnPvfAB2XtrSQiKYw4NFMOKBaj+8n9Xtoq1rmtUA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012, Benjamin Tissoires wrote:

> >> here, you'll find a small C program that allows you to do a pairing of
> >> a new device to a receiver.
> >>
> >> compile it with with gcc -o pairing_tool pairing_tool.c
> >
> > Could this perhaps be provided into Documentation/ or samples/ somewhere?
> > I don't think that Logitech themselves do ship pairing application for
> > Linux, or do they?
> >
> well, I don't have any information about an official pairing tool.
> However, I don't think the kernel is the good place for this stuff.
> Other people started projects based on this code:
> https://bitbucket.org/clach04/logitech-unifying-receiver-tools/ for instance.

Thanks for the pointer. I don't think we need to fully include the pairing 
tool in the kernel, sure.
But at least description of the pairing magic packet, or link such as the 
above might be nice to have.

Thanks,

-- 
Jiri Kosina
SUSE Labs
