Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0GYS4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 14:56:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54486 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0GYS4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 14:56:32 -0400
Message-ID: <4C4C88C3.1050103@zytor.com>
Date: Sun, 25 Jul 2010 11:56:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mrst: remove unused mrst_identify_cpu()
References: <1280033438.2419.5.camel@lenovo>	<4C4BC5ED.3030104@zytor.com> <20100725115524.76138396@lxorguk.ukuu.org.uk>
In-Reply-To: <20100725115524.76138396@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2010 03:55 AM, Alan Cox wrote:
> On Sat, 24 Jul 2010 22:04:45 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> Jacob, is this obsolete or something that will be needed in future versions?
>>
>> It seems that either __mrst_cpu_chip should be killed off, or read-only
>> users should be using the inline instead of __mrst_cpu_chip directly.
> 
> And how is the inline going to access the variable if the variable isn't
> global ...
> 
> Alan

Well, of course it needs to be global.  The "or" in the above sentence
is an xor.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

