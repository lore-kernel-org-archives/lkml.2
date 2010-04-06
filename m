Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0DFU2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:28:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53129 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab0DFU23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:28:29 -0400
Message-ID: <4BBB972B.1030600@zytor.com>
Date: Tue, 06 Apr 2010 13:18:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frank Hu <frank.hu.2001@gmail.com>
CC: Joel Fernandes <agnel.joel@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, kernelnewbies@nl.linux.org
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>	 <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>	 <4BBB7AC9.5060008@zytor.com>	 <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>	 <4BBB8F07.60401@zytor.com> <p2q8f84f9951004061315z7d2be34aj41b5052cf20879f3@mail.gmail.com>
In-Reply-To: <p2q8f84f9951004061315z7d2be34aj41b5052cf20879f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 01:15 PM, Frank Hu wrote:
> 
> thought that you can only configure how to split the VM like 1G/3G or
> 2G/2G. But the DMA zone size, the 128MB space for I/O is not
> configurable. The NORMAL zone size will be deducted based on the VM
> Split and some hard coded DMA zone and 128 MB space size.
> 
> I am not a guru in this space... so I might be wrong.

And you are.  The vmalloc zone (not DMA zone -- that's something
entirely different) is configurable via the vmalloc= kernel command line
option.

	-hpa
