Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab1JXNLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:11:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63129 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1JXNLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <4EA55F0B.1070906@enea.com>
References: <20111019152132.GH29653@arm.com> <4EA55F0B.1070906@enea.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 24 Oct 2011 15:11:13 +0200
X-Google-Sender-Auth: LdDYlFLrGActshOiAsbmA02DpiU
Message-ID: <CAHkRjk6VBgFJTCcBp80wuJrGBp=0Nt302+jRw3TELcT1vFwJ7g@mail.gmail.com>
Subject: Re: Memory leak in isp1760-hcd.c
To: Arvid Brodin <arvid.brodin@enea.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2011 14:50, Arvid Brodin <arvid.brodin@enea.com> wrote:
> Catalin Marinas wrote:
>> I get the following kmemleak report coming from the ISP1760 driver:
>>
> *snip*
>>
>> Is there a race condition between isp1760_endpoint_disable and
>> isp1760_irq?
>
> Yes, I think there is. Thanks for a great bug report!
>
> Please try the patches in following emails.

Thanks. I'll try them next week as I'm at the KS now.

The good news, I'm using this leak as an example in my kmemleak presentations :)

-- 
Catalin
