Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab0EZSW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:22:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56973 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab0EZSWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:22:55 -0400
Message-ID: <4BFD66D9.4070302@zytor.com>
Date: Wed, 26 May 2010 11:22:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, jkosina@novell.com
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if 	add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEB0D5F.8070806@oracle.com>	 <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com>	 <4BEC73B2.2020909@oracle.com> <4BEC7544.1080506@sgi.com>	 <4BEC8161.6050206@zytor.com> <4BFC5080.6030103@sgi.com>	 <4BFC5217.6060804@zytor.com> <4BFC5330.5080907@sgi.com> <AANLkTilNXcS_KQTQ4ZwDt8RQqSrlWUH2R5W87g0vI4xG@mail.gmail.com> <4BFD5D98.6090408@sgi.com>
In-Reply-To: <4BFD5D98.6090408@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 10:42 AM, Mike Travis wrote:
> 
> I'm open for suggestions on how to improve this, but we are shipping
> systems very soon and I don't think we'll get any other change into
> the system until the next update.
> 

You know you've been using that excuse for two years when it comes to
not fixing the bootloader, and I'm starting to be a bit frustrated with
that.

	-hpa
