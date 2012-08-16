Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab2HPO5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:57:31 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37022 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab2HPO5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:57:30 -0400
X-Auth-Info: UJ0/V1zhv1IDV/ehqtc3MDto8u+Z3UAXVAZ1j2SeOVY=
From: Marek Vasut <marex@denx.de>
To: linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: kill MTD_NAND_VERIFY_WRITE
Date: Thu, 16 Aug 2012 16:57:28 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Huang Shijie <b32955@freescale.com>, dedekind1@gmail.com,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Huang Shijie <shijie8@gmail.com>
References: <1344998325-3279-1-git-send-email-shijie8@gmail.com> <201208151409.12390.marex@denx.de> <502CBAA5.4070302@freescale.com>
In-Reply-To: <502CBAA5.4070302@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208161657.28728.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Huang Shijie,

> 于 2012年08月15日 20:09, Marek Vasut 写道:
> > I'd still prefer for this to be rather fixed. It seems to be able to find
> > some obvious mistakes etc.
> 
> could you please point out the mistakes?

Usual stuff -- flaws in drivers, misbehavior of the chip etc

Best regards,
Marek Vasut
