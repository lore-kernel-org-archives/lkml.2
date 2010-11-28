Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0K1LPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 06:15:18 -0500
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:38116 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0K1LPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 06:15:15 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-13.arcor-online.net C1762212520
Message-Id: <E1PMfDt-00012L-Is@be1.7eggert.dyndns.org>
From: Bodo Eggert <7eggert@web.de>
Subject: Re: per-chroot clock module ?
To: jason.vas.dias@gmail.com, Ben Gamari <bgamari@gmail.com>,
        linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sun, 28 Nov 2010 12:15:13 +0100
References: <fTxH4-2pP-5@gated-at.bofh.it> <fTya5-30n-9@gated-at.bofh.it> <fTyD7-3UB-11@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Vas Dias <jason.vas.dias@gmail.com> wrote:

> This would allow one to very easily support websites for totally different
> timezones

Timezones can be set using environment variables.

man 8 tzselect

example:

$ date
Sun Nov 28 12:11:39 CET 2010
$ TZ="America/New_York" date
Sun Nov 28 06:11:46 EST 2010



