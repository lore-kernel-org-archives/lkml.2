Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0LaLL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 06:11:56 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:41032 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0LaLLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 06:11:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
Date: Fri, 31 Dec 2010 12:12:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, aospan@netup.ru
References: <201012310726.31851.liplianin@netup.ru>
In-Reply-To: <201012310726.31851.liplianin@netup.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311212.19715.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

On Friday 31 December 2010 06:26:31 Igor M. Liplianin wrote:
> It uses STAPL files and programs Altera FPGA through JTAG.
> Interface to JTAG must be provided from main device module,
> for example through cx23885 GPIO.

It might be a bit late for this comment (sorry for not having noticed the 
patch set earlier), but...

Do we really need a complete JTAG implementation in the kernel ? Wouldn't it 
better to handle this in userspace with a tiny kernel driver to access the 
JTAG signals ?

-- 
Regards,

Laurent Pinchart
