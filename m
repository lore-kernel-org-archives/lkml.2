Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0HBHTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:19:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49579 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0HBHTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:19:46 -0400
Message-ID: <4C567156.6050000@zytor.com>
Date: Mon, 02 Aug 2010 00:18:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
References: <4C56701B.1030000@kernel.org>
In-Reply-To: <4C56701B.1030000@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 12:13 AM, Yinghai Lu wrote:
> 
> Seperate early_console_setup from tty.c
> also make main.c to include printf.c/string.c/cmdline.c
> 
> will reuse early_serial_console.c/string.c/printf.c/cmdline.c in compressed/misc.c
> 


The way to reuse files in boot/compressed/ would be just to create .c
files in boot/compressed/ with, for example:

/* string.c */
#include "../string.c"

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

