Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab2FOX0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:26:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48422 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab2FOX0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:26:40 -0400
Message-ID: <4FDBC4A7.8050507@linux.vnet.ibm.com>
Date: Fri, 15 Jun 2012 18:26:31 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Nitin Gupta <ngupta@vflare.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Nick Piggin <npiggin@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
References: <1337133919-4182-1-git-send-email-minchan@kernel.org> <1337133919-4182-3-git-send-email-minchan@kernel.org> <4FB4B29C.4010908@kernel.org> <1337266310.4281.30.camel@twins> <4FDB5107.3000308@linux.vnet.ibm.com> <7e925563-082b-468f-a7d8-829e819eeac0@default> <4FDB66B7.2010803@vflare.org> <10ea9d19-bd24-400c-8131-49f0b4e9e5ae@default> <4FDB8808.9010508@linux.vnet.ibm.com> <9c6c8ae0-0212-402d-a906-0d0c61e5e058@default> <4FDB92CF.1070603@vflare.org> <4ffbc3e8-900b-4669-b6ab-e8c066f28c63@default> <4FDBA7CC.6060407@vflare.org>
In-Reply-To: <4FDBA7CC.6060407@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061523-3534-0000-0000-00000967DF19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 04:23 PM, Nitin Gupta wrote:

> On 06/15/2012 01:13 PM, Dan Magenheimer wrote:

>>

>> OK, it's your code and I'm just making a suggestion. I will shut up now ;-)
>>
> 
> I'm always glad to hear your opinions and was just trying to discuss the
> points you raised. I apologize if I sounded rude.

Same here. It's always good to go back and rethink your assumptions.
Thanks Dan!

Thanks,
Seth

