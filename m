Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0DGFiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 01:38:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35876 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0DGFiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 01:38:17 -0400
Message-ID: <4BBC1807.1090004@zytor.com>
Date: Tue, 06 Apr 2010 22:28:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chetan Nanda <chetannanda@gmail.com>
CC: Venkatram Tummala <venkatram867@gmail.com>,
       Joel Fernandes <agnel.joel@gmail.com>,
       Frank Hu <frank.hu.2001@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, kernelnewbies@nl.linux.org
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>	 <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>	 <4BBB7AC9.5060008@zytor.com>	 <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>	 <4BBB8F07.60401@zytor.com>	 <w2p9ff7a3bc1004061301v6cc76e1g1e573468b1b8807d@mail.gmail.com>	 <q2iacff6c2b1004061528t28f1337eq977aabf8fe71bc22@mail.gmail.com> <u2o7f245da81004062105w1f7d3416n7855472d28e8bcfd@mail.gmail.com>
In-Reply-To: <u2o7f245da81004062105w1f7d3416n7855472d28e8bcfd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 09:05 PM, Chetan Nanda wrote:
> 
> I have a question here, what if I have a 32bit system with 2GB of RAM,
> so in that case my 896MB - 2GB RAM would be in accessible?
> What my understanding on the subject is:
> Only 896 MB of physical RAM is directly mapped on to kernel 1G virtual
> address space. And we still require page table settings to do that (page
> table would be identity mapping). But for rest of RAM, i.e. whenever
> there is need to access physical RAM beyond 896MB then that page will be
> mapped on to pages from 128MB kernel virtual address space (1GB - 896MB
> = 128MB), and AFAIK kmap is just for that.
>  
> Please correct me if i am wrong
> 

Correct.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

