Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab0FBPpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:45:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48979 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab0FBPpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:45:41 -0400
Date: Wed, 02 Jun 2010 17:46:22 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 07/11] USB: gadget: g_multi: added documentation and INF
 files
In-reply-to: <AANLkTikAhJXiKGzyK7j3V7ev_6f2mn8f-A9tDmgdHy9I@mail.gmail.com>
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org, "mina86@mina86.com" <mina86@mina86.com>
Message-id: <op.vdojfktu7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1275481997.git.mina86@mina86.com>
 <5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
 <e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
 <785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
 <5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
 <17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
 <381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
 <c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
 <AANLkTikAhJXiKGzyK7j3V7ev_6f2mn8f-A9tDmgdHy9I@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jun 2010 15:02:54 +0200, Xiaofan Chen <xiaofanc@gmail.com> wrote:
> [Version]
> Signature="$Windows NT$"
> Class=Ports
> ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
> Provider=%MFGNAME%
> LayoutFile=layout.inf
> CatalogFile=%MFGFILENAME%.cat

So, what is this cat file for?  I changed the IDs and the INF file started
working even though I expected that this file will be required.  I'm wondering
is it because I have something installed on my Windows box that others may
miss?

And what's with the layout.inf.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
