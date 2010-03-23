Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0CWBGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:06:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:33428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0CWBGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:06:16 -0400
Message-ID: <4BA813A4.1010704@kernel.org>
Date: Mon, 22 Mar 2010 18:04:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
References: <4BA6EA62.1030603@kernel.org> <20100321.210023.209981130.davem@davemloft.net> <4BA6F1F6.3070102@kernel.org> <20100321.213350.176660494.davem@davemloft.net> <20100322092809.GA20607@elte.hu> <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain> <20100322193720.GA2844@elte.hu> <4BA7CE1B.9070109@kernel.org> <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain> <4BA7EE72.7000507@kernel.org> <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain> <4BA80019.5000900@kernel.org> <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 05:45 PM, Thomas Gleixner wrote:
> B1;2005;0cYinghai,
>>
>> to make x86 to use lmb, we need to extend lmb to have find_early_area.
> 
> Why ?

unless you want to dump two users of find_e820_area_size()

YH
  
