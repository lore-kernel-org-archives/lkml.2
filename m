Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab1BNSOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:14:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56950 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1BNSOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jiGwWSMufQYj9SuoLRhi3ZxuoQsjNcnbInCGpaoW7mXfQz6BAOi9usayukuYdQHF6A
         h9TGoxOVWRTh0H6n9Lle+vyfBtod6Sxnk5h9PSClr/l9zKRuP/H5B4TQOL0u4vBKB941
         OPJR2/+ZjDtbct4U1WUIdKGZp8t65ATUPdnTM=
MIME-Version: 1.0
In-Reply-To: <20110214162247.GX18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-16-git-send-email-tj@kernel.org>
	<4D5729A7.7070706@kernel.org>
	<20110214113221.GG18742@htj.dyndns.org>
	<AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
	<20110214161249.GV18742@htj.dyndns.org>
	<AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
	<20110214162247.GX18742@htj.dyndns.org>
Date: Mon, 14 Feb 2011 10:14:15 -0800
X-Google-Sender-Auth: 3DlHT_BAMTUa1pWY3p95DNUJRvI
Message-ID: <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 8:22 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Feb 14, 2011 at 08:17:46AM -0800, Yinghai Lu wrote:
>> why not do it at first point ?
>>
>> numa_register_meminfo() should only take care of creating correctly
>> struct numa_meminfo.
>
> No, register meminfo doesn't create numa_meminfo.  It sets up system
> states according to the configuration information in numa_meminfo, and
> I really have no idea what you're arguing for or against.  What's your
> point?

I just want seperate setup_bootmem  ( and maybe init_memory_mapping_high...)
out  that __register__ function.

that __register__ function do some sth like memblock_register to
early_node_map[]
looks reasonable.

Yinghai
