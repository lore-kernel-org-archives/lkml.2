Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0JKSTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:19:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58958 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab0JKSTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:19:40 -0400
Message-ID: <4CB3552C.5050808@zytor.com>
Date: Mon, 11 Oct 2010 11:19:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, setup: Check early serial console per string instead
 of one char
References: <4CB34E82.8030802@kernel.org>
In-Reply-To: <4CB34E82.8030802@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 10:50 AM, Yinghai Lu wrote:
> 
> Move out serial_putchar() calling out of putchar
> Let puts() to call serial_putchar() directly.
> 
> So only need to check early_serial_base per string.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

This seems to add a bunch of code for zero benefit.  Testing a global
variable is zero cost compared to either a BIOS call or poking a serial
port.

	-hpa
