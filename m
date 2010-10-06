Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0JFDF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:05:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50653 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0JFDF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:05:57 -0400
Message-ID: <4CABE739.8050001@kernel.org>
Date: Tue, 05 Oct 2010 20:04:25 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatches in memblock
References: <4CABAAB4.3090707@zytor.com> <4CABB4FD.2090304@kernel.org> <4CABDF3A.2020501@zytor.com>
In-Reply-To: <4CABDF3A.2020501@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 07:30 PM, H. Peter Anvin wrote:
> 
> Wrong functions!  Furhtermore, at least the tip tree definitely does not
> have __init_memblock here:
> 

Nevermind.  I had missed that Ingo had put stuff into core/memblock on
top of x86/memblock, just to be confusing.

	-hpa
