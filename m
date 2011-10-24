Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1JXNqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:46:42 -0400
Received: from sestofw01.enea.se ([192.36.1.252]:8614 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932478Ab1JXNqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:46:40 -0400
Message-ID: <4EA56C3A.6080204@enea.com>
Date: Mon, 24 Oct 2011 15:46:34 +0200
From: Arvid Brodin <arvid.brodin@enea.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Memory leak in isp1760-hcd.c
References: <20111019152132.GH29653@arm.com> <4EA55F0B.1070906@enea.com> <CAHkRjk6VBgFJTCcBp80wuJrGBp=0Nt302+jRw3TELcT1vFwJ7g@mail.gmail.com>
In-Reply-To: <CAHkRjk6VBgFJTCcBp80wuJrGBp=0Nt302+jRw3TELcT1vFwJ7g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.23.1.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> On 24 October 2011 14:50, Arvid Brodin <arvid.brodin@enea.com> wrote:
>> Catalin Marinas wrote:
>>> I get the following kmemleak report coming from the ISP1760 driver:
>>>
>> *snip*
>>> Is there a race condition between isp1760_endpoint_disable and
>>> isp1760_irq?
>> Yes, I think there is. Thanks for a great bug report!
>>
>> Please try the patches in following emails.
> 
> Thanks. I'll try them next week as I'm at the KS now.
> 
> The good news, I'm using this leak as an example in my kmemleak presentations :)
> 

Hehe, what can I say... I'm honoured to be made an example of! ;D

-- 
Arvid Brodin
Enea Services Stockholm AB
