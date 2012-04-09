Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2DIWHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:07:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55314 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab2DIWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:07:39 -0400
Message-ID: <4F835D53.3090201@linux.vnet.ibm.com>
Date: Mon, 09 Apr 2012 17:06:11 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: fix memory leak
References: <1333376036-9841-1-git-send-email-sjenning@linux.vnet.ibm.com> <d858d87f-6e07-4303-a9b3-e41ff93c8080@default> <4F7C7626.40506@linux.vnet.ibm.com> <4F83454A.3050007@linux.vnet.ibm.com> <20120409214316.GB535@kroah.com>
In-Reply-To: <20120409214316.GB535@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040922-7282-0000-0000-0000080EB4D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 04:43 PM, Greg Kroah-Hartman wrote:
> A: No.
> Q: Should I include quotations after my reply?
> 
> http://daringfireball.net/2007/07/on_top

Noted. I only included what I did to keep the Ack chain in the
message, which I guess was unnecessary.

> On Mon, Apr 09, 2012 at 03:23:38PM -0500, Seth Jennings wrote:
>> Hey Greg,
>>
>> Haven't heard back from you on this patch and it needs to
>> get into the 3.4 -rc releases ASAP.  It fixes a substantial
>> memory leak when frontswap/zcache are enabled.
>>
>> Let me know if you need me to repost.
>>
>> The patch was sent on 4/2.
> 
> 5 meager days ago, with a major holliday in the middle, not to mention a
> conference as well.  That's bold.

Sorry about that.  Forgot about the summit and the holiday :-/

The date was not to convey "It's been a whole week! Why the delay?",
but to help you find the original patch in your stack of emails.

> It is not lost, is in my queue, and will get to Linus before 3.4-final
> comes out, don't worry.

I'll be more patient (and take into account summits/holiday) for replies.

Thanks Greg!

--
Seth

