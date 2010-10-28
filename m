Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab0J1Urv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:47:51 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56296 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab0J1Urp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:47:45 -0400
X-SpamScore: -5
X-BigFish: VS-5(z3b68iz98dNzz1202hzzz2dh2a8h63h)
X-Spam-TCS-SCL: 2:0
Message-ID: <4CC9E168.7050903@freescale.com>
Date: Thu, 28 Oct 2010 15:47:36 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20101013 Fedora/2.0.8-2.fc13 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
References: <4CC893CD.7020701@freescale.com> <20101027231948.5e62dd09@lxorguk.ukuu.org.uk> <4CC9DE56.8070707@freescale.com>
In-Reply-To: <4CC9DE56.8070707@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 20:48:08.0882 (UTC) FILETIME=[6D9B8920:01CB76E1]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> Assuming that both calls to tty_init_termios(tty) return 0, these three lines
> will be executed twice:

Ugh, never mind.  I didn't notice the "return ret;" after it unlocks the kernel.

-- 
Timur Tabi
Linux kernel developer at Freescale

