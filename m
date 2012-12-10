Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab2LJN3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:29:09 -0500
Received: from ns.iliad.fr ([212.27.33.1]:60356 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2LJN3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:29:07 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 08:29:07 EST
Message-ID: <50C5E143.4070306@freebox.fr>
Date: Mon, 10 Dec 2012 14:18:59 +0100
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mircea Gherzan <mgherzan@gmail.com>
CC: rmk+kernel@arm.linux.org.uk, Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: net: bpf_jit_32: fix kzalloc gfp/size mismatch.
References: <1354804718-1662-1-git-send-email-nschichan@freebox.fr> <50C2760A.9070406@gmail.com>
In-Reply-To: <50C2760A.9070406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2012 12:04 AM, Mircea Gherzan wrote:
> Am 06.12.2012 15:38, schrieb Nicolas Schichan:
[...]
> Acked-by: Mircea Gherzan<mgherzan@gmail.com>

Hi,

Thanks for acking those two patches.

Shall I send them to the patch system now ?

Regards,

-- 
Nicolas Schichan
Freebox SAS
