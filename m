Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0DWCQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:16:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48020 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab0DWCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NgyaqVVm3Yi6+s5zj5K1JVL2EZl4XYvjLdT3/OIisRkpQZbw3VX3bcJLRxkyxl3+iF
         qBX369CDLi6xYdnDhMuEywOqpDGI3L2C8mGlRaXVWxw/w0AgAabj84u8xUoVISj60NIV
         BxZHU7HoRdmE32WRibEh1p9p0CCnrc8htsraw=
Message-ID: <4BD102E5.7080006@pobox.com>
Date: Thu, 22 Apr 2010 22:16:05 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.34-rc3 v2 Disable R_OK (Early ACK) on SII 3726 PMP
References: <g2ida824cf31004141843p41f7b21fz25927e3c6faeeed7@mail.gmail.com> <l2jda824cf31004201352y5fcdfa40g2ecb5dbb1706bf88@mail.gmail.com>
In-Reply-To: <l2jda824cf31004201352y5fcdfa40g2ecb5dbb1706bf88@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 04:52 PM, Grant Grundler wrote:
> ping? Can this patch please be applied?

Apologies for the delay, I had been pulled away from libata this week by 
baby stuff :/


> I was assuming this will show up here:
>     http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=shortlog;h=refs/heads/upstream-linus

Nope, upstream-linus is always a temporary branch.

#upstream-fixes is where 2.6.X-rcY changes are found (though typically 
these are pushed upstream ASAP)

#upstream is the development branch for 2.6.(X+1), where this change can 
[now] be found.

	Jeff



