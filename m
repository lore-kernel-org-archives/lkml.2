Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1EPM0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:26:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47625 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab1EPM0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:26:09 -0400
Message-ID: <4DD117DB.4070204@ti.com>
Date: Mon, 16 May 2011 13:26:03 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: Fix off-by-one value range checking for tps65910_i2c_write
References: <1305278037.2713.1.camel@phoenix> <20110513174606.GV8970@sortiz-mobl>
In-Reply-To: <20110513174606.GV8970@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/11 18:46, Samuel Ortiz wrote:
> Hi Axel,
> 
> On Fri, May 13, 2011 at 05:13:57PM +0800, Axel Lin wrote:
>> If bytes == (TPS65910_MAX_REGISTER + 1), we have a buffer overflow when
>> doing memcpy(&msg[1], src, bytes).
> This code is going through Liam's tree, I'm adding him to this thread.
> Liam, please add my Acked-by to this patch, if you think it's needed.
> 

Axel, could you resend to me with Samuels Ack and I'll apply.

Thanks

Liam
