Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0C0WAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 18:00:48 -0400
Received: from [85.183.11.32] ([85.183.11.32]:48713 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0C0WAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 18:00:46 -0400
Date: Sat, 27 Mar 2010 23:00:39 +0100
From: =?utf-8?Q?J=F6rn?= Engel <joern@dublin.logfs.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       romieu@fr.zoreil.com
Subject: Re: [Regression] r8169: enable 64-bit DMA by default for PCI
	Express devices (v2)
Message-ID: <20100327220039.GA2083@Dublin.logfs.org>
References: <20100315151041.GA15667@Dublin.logfs.org> <20100315.115748.13754030.davem@davemloft.net> <51f3faa71003151628g5edc4d7av8916ac76cb337bfe@mail.gmail.com> <20100316083501.GA3489@Dublin.logfs.org> <51f3faa71003161630g69160ea9tc1a2d448682632e5@mail.gmail.com> <51f3faa71003251756h17374375yd3a5d2acee2ffab9@mail.gmail.com> <20100326091234.GA11959@Dublin.logfs.org> <4BAD65A0.7090309@gmail.com> <20100327063838.GB11959@Dublin.logfs.org> <4BAE4464.9060909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BAE4464.9060909@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 March 2010 11:46:12 -0600, Robert Hancock wrote:
>
> Hm, do you recall/have the details of what happened with the other card?

It lost interrupts.  I had a testcase that should have received three
interrupts and only two were received by the driver.  100%
reproducable.  Card used MSI-Interrupts (no MSI-X) and worked
reasonably well otherwise.  But it is a prototype, so the card is just
as likely to be the cause as the motherboard.

> It's possible this is some general problem with that machine/motherboard  
> and not actually an issue with what the driver is doing. What kind of  
> board is that?

Possible, yes.  But I wouldn't know how to prove it.
Asrock G31M-S with Intel E5200.

J�rn
