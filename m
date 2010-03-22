Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0CVD1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 23:27:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:35001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0CVD1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 23:27:54 -0400
Message-ID: <4BA6E353.7070306@kernel.org>
Date: Sun, 21 Mar 2010 20:26:11 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/20] x86: early_res and irq_desc
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org> <1269225336.8599.69.camel@pasglop>
In-Reply-To: <1269225336.8599.69.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 07:35 PM, Benjamin Herrenschmidt wrote:
> On Sun, 2010-03-21 at 00:13 -0700, Yinghai Lu wrote:
>> 01 - 06: early_res related
>> 07 - 15: irq_desc releated
>> 19 - 20: pci related
> 
> First of all, please post separate series, it's hard enough as it-is.
> 
ok, next version seperate early_res and irq_desc related.

YH

