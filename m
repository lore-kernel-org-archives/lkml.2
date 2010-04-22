Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0DVNad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:30:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35741 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab0DVNa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:30:28 -0400
Message-ID: <4BD04EA1.4000403@zytor.com>
Date: Thu, 22 Apr 2010 06:26:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [patch] vt: deactive Shift In/Out in unicode mode
References: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr> <20100419153136.3585281f@lxorguk.ukuu.org.uk> <alpine.LSU.2.01.1004191812570.25222@obet.zrqbmnf.qr> <4BCE3D88.4010502@zytor.com> <alpine.LSU.2.01.1004221013430.27555@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1004221013430.27555@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 01:39 AM, Jan Engelhardt wrote:
> 
> Indeed 0x0e 0x71 0x0f generates the same output as U+2501.
> 
> I can't say when the last time was that I saw SISO in use, though.

Probably a lot more recently than you think, especially if you are
dealing with terminal input from other hosts.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

