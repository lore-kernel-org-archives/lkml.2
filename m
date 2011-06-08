Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1FHVjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:39:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58248 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1FHVjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:39:15 -0400
Message-ID: <4DEFEBE0.9080208@kernel.org>
Date: Wed, 08 Jun 2011 14:38:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Jim Bos <jim876@xs4all.nl>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <20110608193833.GA29855@srcf.ucam.org> <4DEFD220.5040507@kernel.org> <20110608195250.GB30256@srcf.ucam.org> <4DEFD58D.5060402@kernel.org> <20110608200903.GA30694@srcf.ucam.org> <4DEFDA4A.9080500@kernel.org> <20110608203037.GA31052@srcf.ucam.org> <4DEFDD69.7010000@kernel.org> <20110608204244.GA31484@srcf.ucam.org> <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com> <20110608212813.GB32056@srcf.ucam.org>
In-Reply-To: <20110608212813.GB32056@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DEFEBE8.0042,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 02:28 PM, Matthew Garrett wrote:
> E820 limits us to 128 ranges, and systems I'm looking at right now are 
> already using over 140 boot services regions.

parse_setup_data() is used to handle entries above 128.

Yinghai
