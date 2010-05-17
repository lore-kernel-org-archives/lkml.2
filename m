Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0EQFuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:50:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57993 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0EQFuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:50:21 -0400
Message-ID: <4BF0D90E.5030503@zytor.com>
Date: Sun, 16 May 2010 22:50:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 8/8] input: do not select i8042 for x86 mid
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-9-git-send-email-jacob.jun.pan@linux.intel.com> <alpine.LFD.2.00.1005170045160.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005170045160.3368@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2010 03:48 PM, Thomas Gleixner wrote:
> On Fri, 14 May 2010, Jacob Pan wrote:
> 
>> From: Jacob Pan <jacob.jun.pan@intel.com>
>>
>> Moorestown does not have i8042 based keyboard controller, so give
>> an option to deselect i8042 for non-pc mid
>>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> Still sending patches to your other self ? :)
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Though this patch should go via Dmitry (Cc'ed).
> 

Dmitry -- let us know if you want us to take this patch via -tip,
otherwise I'll assume you are handling it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

