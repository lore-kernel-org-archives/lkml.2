Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab0FNPM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:12:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50809 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0FNPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:12:26 -0400
Message-ID: <4C1646C4.1010002@zytor.com>
Date: Mon, 14 Jun 2010 08:12:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com> <4C11FFC0.1030006@jp.fujitsu.com> <4C1275BF.3070605@zytor.com> <4C158BCF.6000303@jp.fujitsu.com> <4C15E7F4.9090607@jp.fujitsu.com>
In-Reply-To: <4C15E7F4.9090607@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 01:27 AM, Kenji Kaneshige wrote:
> 
> Please ignore above. I misunderstood the architectural limit of physical
> address in x86 32-bit mode. It is not 40-bits, but 52-bits.
> 

Well, it can be anywhere from 32 to 52 bits, depending on the hardware.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

