Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab0GPE0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 00:26:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38511 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab0GPE0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 00:26:03 -0400
Message-ID: <4C3FDF43.6030203@zytor.com>
Date: Thu, 15 Jul 2010 21:25:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Michal Schmidt <mschmidt@redhat.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
References: <20100713185816.2866.17837.stgit@localhost.localdomain>	<20100713185957.2866.50995.stgit@localhost.localdomain>	<20100714160704.GA10473@kryptos.osrc.amd.com>	<20100714232201.00433aa9@hammerfall> <20100714233102.0f64614b@hammerfall>
In-Reply-To: <20100714233102.0f64614b@hammerfall>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 02:31 PM, Michal Schmidt wrote:
> 
> This suggests that another way to fix my problem would be this (tested):
> 

This is a change of semantics from an AND to an OR across CPUs...

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

