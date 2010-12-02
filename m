Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0LBNRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:17:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41263 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab0LBNRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:17:05 -0500
Date: Thu, 2 Dec 2010 14:17:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stanley Gan <stanley.ganyezu@gmail.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: debug kernel using two laptops without serial port
Message-ID: <20101202131700.GA28343@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stanley Gan <stanley.ganyezu@gmail.com>,
	'LKML' <linux-kernel@vger.kernel.org>
References: <20101130153839.GM15818@bombadil.infradead.org>
 <4CF52652.4030802@kernel.org>
 <20101130163150.GA25668@bombadil.infradead.org>
 <20101130175317.GB25668@bombadil.infradead.org>
 <20101130210938.GF25668@bombadil.infradead.org>
 <4CF62EE0.7040607@kernel.org>
 <20101201124445.GG25668@bombadil.infradead.org>
 <4CF6595A.6010104@kernel.org>
 <20101201155026.GH25668@bombadil.infradead.org>
 <4cf79779.2b3bec0a.5180.1bb9@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4cf79779.2b3bec0a.5180.1bb9@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 08:56:19PM +0800, Stanley Gan wrote:
> Hi All,
> 	I have two dell laptops 1015. For studying Linux kernel, I want to
> let one run debugging Linux as client, the other as host. The two laptops
> don't have serial port, just have LAN and usb ports. How can I configure
> them to get early kernel print message? I ever asked a lot of people, but
> don't get answers. Please give me some practical advices, thanks in advance.

Take a look at <Documentation/networking/netconsole.txt> in the kernel
sources.

-- 
Regards/Gruss,
Boris.
