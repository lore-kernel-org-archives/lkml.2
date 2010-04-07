Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab0DGCTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:19:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48215 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab0DGCTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:19:35 -0400
Message-ID: <4BBBE976.1000603@zytor.com>
Date: Tue, 06 Apr 2010 19:09:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Venkatram Tummala <venkatram867@gmail.com>
CC: Xianghua Xiao <xiaoxianghua@gmail.com>,
       Youngwhan Song <breadncup@gmail.com>,
       Joel Fernandes <agnel.joel@gmail.com>,
       Frank Hu <frank.hu.2001@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-kernel@zh-kernel.org" <linux-kernel@zh-kernel.org>,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com> 	<g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com> 	<4BBB7AC9.5060008@zytor.com> <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com> 	<4BBB8F07.60401@zytor.com> <w2p9ff7a3bc1004061301v6cc76e1g1e573468b1b8807d@mail.gmail.com> 	<q2iacff6c2b1004061528t28f1337eq977aabf8fe71bc22@mail.gmail.com> 	<3715922601579231267@unknownmsgid> <4BBBC470.4050002@zytor.com> 	<q2he6bf505b1004061847l31b2fe15v31d1556862d3a2f9@mail.gmail.com> <n2uacff6c2b1004061904v5d290fa6v909e2e5fe32ff910@mail.gmail.com>
In-Reply-To: <n2uacff6c2b1004061904v5d290fa6v909e2e5fe32ff910@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 07:04 PM, Venkatram Tummala wrote:
> Hey Xiao,
> 
> last 128MB is not used for highmem. last 128MB is used for data
> structures(page tables etc.) to support highmem .  Highmem is not
> something which is "INSIDE" Kernel's Virtual Address space. Highmem
> refers to a region of "Physical memory" which can be mapped into
> kernel's virtual address space through page tables.
> 
> Regards,
> Venkatram Tummala
> 

Not quite.

The vmalloc region is for *anything which is dynamically mapped*, which
includes I/O, vmalloc, and HIGHMEM (kmap).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

