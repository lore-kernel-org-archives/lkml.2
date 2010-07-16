Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107Ab0GPAOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:14:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59855 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935097Ab0GPAOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:14:10 -0400
Message-ID: <4C3FA3DB.4010507@zytor.com>
Date: Thu, 15 Jul 2010 17:12:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
References: <4C3F8B46.7080809@kernel.org>
In-Reply-To: <4C3F8B46.7080809@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 03:27 PM, Yinghai Lu wrote:
> 
> to save the early_serial_base.
> 
> Also bootloader could fill that field, so setup code could reuse it.
> 
> decompress code could reuse early serial console from setup code.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

What's the point with this over what we currently have?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

