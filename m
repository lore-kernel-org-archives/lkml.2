Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1CXX1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:27:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64764 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab1CXX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t94mXDC0qYKcIsVdAs1V1Ay7ffk51DRNQDAeMQjQ+Hgc9Z61AYKgkvqMS3N7eO2w0t
         qMDi6m8rGEGvLlVScvXD6/c9nKru0cX4ODJYOSTnQXAKZX2cKctsSwap7RlwjmDIPpkl
         bS9alWd4XuMl91+FxvWzvt/skUpTsdGYaMk6Y=
Message-ID: <4D8BD342.3@gmail.com>
Date: Thu, 24 Mar 2011 16:26:58 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 14/21]drivers:staging Remove extra comma.
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>	<1300994819-30930-14-git-send-email-justinmattock@gmail.com> <20110324232036.78ded5cc@lxorguk.ukuu.org.uk>
In-Reply-To: <20110324232036.78ded5cc@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 04:20 PM, Alan Cox wrote:
> On Thu, 24 Mar 2011 12:26:52 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> The patch below removes an extra comma from various parts
>> of the kernel. Please have a look when you have time, and let
>> me know if its legit or not.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Can you split the gma500 one out and send it my way instead of via
> trivial/Greg otherwise it'll collide with some of the big cleanup work
> going on I fear.
>
> And ack for the 3 intel ones (langwell_gpio, max3110, intel_mid_battery)
> to go in directly.
>

sure... finishing up on some SELinux stuff, then I will resend for you..

Justin P. Mattock
