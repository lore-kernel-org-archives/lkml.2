Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab0I0E15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 00:27:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44922 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab0I0E14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 00:27:56 -0400
Message-ID: <4CA01D26.3030906@zytor.com>
Date: Sun, 26 Sep 2010 21:27:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>,
        Alexander Chumachenko <ledest@gmail.com>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: fs hang in 2.6.27.y | Fwd: [Bug 15658] New: [PATCH] x86 constant_test_bit()
 prone to misoptimization with gcc-4.4
References: <20100827213629.GA11342@osdn.org.ua> <20100923165022.6982ffc1.akpm@linux-foundation.org> <20100926115354.GA30247@osdn.org.ua> <AANLkTiniAprv-rz0QQD540g7S1jbj8Na+e78Ro2R8Koa@mail.gmail.com>
In-Reply-To: <AANLkTiniAprv-rz0QQD540g7S1jbj8Na+e78Ro2R8Koa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2010 10:00 AM, Linus Torvalds wrote:
> On Sun, Sep 26, 2010 at 4:53 AM, Michael Shigorin<mike@osdn.org.ua>  wrote:
>>
>> The simplicity of adding that somewhat went over my head --
>> please find attached the corrected original patch against HEAD
>> with Signed-off-by: for both of us.  led@ didn't change cosmetics
>> -- thanks for providing it anyways.
>
> Ok, I think this patch is probably the right thing to do at this stage
> - and we should think about trying to see if we can improve code
> generation later.
>
> So: "Acked-by: Linus Torvalds<torvalds@linux-foundation.org>"
>
> Ingo/Thomas/Peter - I can take this either from the x86 tree, or
> directly. Just let me know. Or do you have any alternate suggestions
> that would be appropriate?
>

(Back home now)

Yes, this patch is clearly The Right Thing.  I'll add it to the -tip 
tree and assuming no unexpected problems will send you a pull request 
tomorrow.

	-hpa
