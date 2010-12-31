Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0LaL1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 06:27:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:45438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0LaL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 06:27:50 -0500
Message-ID: <4D1DBE2A.5080003@infradead.org>
Date: Fri, 31 Dec 2010 09:27:38 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, aospan@netup.ru
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
References: <201012310726.31851.liplianin@netup.ru> <201012311212.19715.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012311212.19715.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 31-12-2010 09:12, Laurent Pinchart escreveu:
> Hi Igor,
> 
> On Friday 31 December 2010 06:26:31 Igor M. Liplianin wrote:
>> It uses STAPL files and programs Altera FPGA through JTAG.
>> Interface to JTAG must be provided from main device module,
>> for example through cx23885 GPIO.
> 
> It might be a bit late for this comment (sorry for not having noticed the 
> patch set earlier), but...
> 
> Do we really need a complete JTAG implementation in the kernel ? Wouldn't it 
> better to handle this in userspace with a tiny kernel driver to access the 
> JTAG signals ?
> 
Laurent,

Igor already explained it. From what I understood, the device he is 
working has a firmware that needs to be loaded via JTAG/FPGA.

Actually, I liked the idea, as the FPGA programming driver could be
useful if other drivers have similar usecases.

Cheers,
Mauro
