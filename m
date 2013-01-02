Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3ABSFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:05:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52763 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3ABSFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:05:20 -0500
Message-ID: <50E476C2.7060300@zytor.com>
Date: Wed, 02 Jan 2013 10:04:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com
Subject: Re: BUG: unable to handle kernel paging request at 000000effd870020
References: <20130102172107.GA26761@gulag1.americas.sgi.com>
In-Reply-To: <20130102172107.GA26761@gulag1.americas.sgi.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 09:21 AM, Nathan Zimmer wrote:
> I am getting an early boot problem. It only happens on the larger of the
> machines I haven't seen it crop up on machines with more then 512 GB of ram.
> It shows in the latest linus kernel too.
> 
> I am (wildly) guessing that what is happening is that the new_memmap that is
> being passed to bios is somehow placed incorrectly.  
> I have come up with a workaround.  By placing it the DMA area the issue goes
> away but that doesn't seem like a real fix. 
>

What does your memory map look like?

	-hpa

