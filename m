Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1AJSK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:10:29 -0500
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:53350 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619Ab1AJSK0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:10:26 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net C5D0A5A296
Subject: Re: [InfraSchlot SPAM Check] Re: [PATCH] DVB Satellite Channel Routing support for DVB-S
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: =?iso-8859-1?Q?Thomas_Schl=F6ter?= <thomas.schloeter@gmx.net>
In-Reply-To: <201101101828.40752@orion.escape-edv.de>
Date: Mon, 10 Jan 2011 19:10:19 +0100
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C20366D6-935B-43DE-8A73-9C4B6B5A3051@gmx.net>
References: <BDD0B014-3AD5-4693-82D9-026F47A7F8A4@gmx.net> <C8296DFF-0E53-4AA2-A6ED-CA8B83D424F2@gmx.net> <4D2B2BA6.7030009@linuxtv.org> <201101101828.40752@orion.escape-edv.de>
To: linux-media@vger.kernel.org
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oliver,

Am 10.01.2011 um 18:28 schrieb Oliver Endriss:

> Ack, this stuff should be implemented as a userspace library.
> (Btw, there is an experimental unicable patch for VDR.)

Yes, there is. I have not testet it as I am going to use MythTV, but for what I have read in some forums, many people have problems using that patch. This is why I decided to make a kernel implementation for my system. But I agree it could also be implemented as a wrapper application between frontend device and viewer application (the quick and dirty way) or native support in a userspace library (which will take some time until it is used in all DVB applications).

What I thought makes my solution attractive is, that you can even use dvbscan, szap etc. without modification, which works perfectly in my setup. But anyway the purpose might be too special to have it inside the kernel.

Regards,
Thomas