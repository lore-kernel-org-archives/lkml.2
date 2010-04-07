Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0DGGOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 02:14:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54060 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0DGGO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 02:14:26 -0400
Message-ID: <4BBC2086.6090708@zytor.com>
Date: Tue, 06 Apr 2010 23:04:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Venkatram Tummala <venkatram867@gmail.com>
CC: Chetan Nanda <chetannanda@gmail.com>,
       Joel Fernandes <agnel.joel@gmail.com>,
       Frank Hu <frank.hu.2001@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, kernelnewbies@nl.linux.org
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com> 	<g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com> 	<4BBB7AC9.5060008@zytor.com> <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com> 	<4BBB8F07.60401@zytor.com> <w2p9ff7a3bc1004061301v6cc76e1g1e573468b1b8807d@mail.gmail.com> 	<q2iacff6c2b1004061528t28f1337eq977aabf8fe71bc22@mail.gmail.com> 	<u2o7f245da81004062105w1f7d3416n7855472d28e8bcfd@mail.gmail.com> 	<4BBC1807.1090004@zytor.com> <h2pacff6c2b1004062257mc8552d81u33322c43e47502c9@mail.gmail.com>
In-Reply-To: <h2pacff6c2b1004062257mc8552d81u33322c43e47502c9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 10:57 PM, Venkatram Tummala wrote:
> Just a note Chetan.
> 
> We can't exactly say that we require "page table settings" to map that
> 896 MB of physical ram. It is an identity mapped segment (1-1 mapping).
> So, we dont require the "page tables".  Virtual address will be equal to
> Physical Address + Page Offset. It is just an addition of offset
> 

No, we still need page tables for the identity-mapped segment.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

