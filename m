Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1CKQl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:41:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50462 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1CKQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=OgUC6yOpxetu5wMrtjP+1TUXKIGRzJkrVWq9K2p0yMXdZZ7EagLydU4f1XUH/dq443
         gmUm07YUsm8VplZwNl3t+S4sa7vuGMhH9z1n+hbqWYxsMOLHJgQRn4R1Yn3euvk9ZfJ1
         4uKrVWCqQD569SNKnhvM3NseJk2SVa3hd7YPs=
Message-ID: <4D7A50B2.9030603@linaro.org>
Date: Fri, 11 Mar 2011 16:41:22 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <20110311160815.GA7426@kroah.com> <4D7A4BDE.7050206@linaro.org> <20110311163628.GB9291@kroah.com>
In-Reply-To: <20110311163628.GB9291@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 04:36 PM, Somebody in the thread at some point said:

>> Is it true that for on-board devices, it can sometimes be legitimate
>> and useful to be able to deliver platform_data from the board file
>> through to stuff on a USB bus, same as you would for memory mapped,
>> I2C, other busses?
>>
>> Or is that it since it is USB, it can never be useful or legitimate,
>> no matter what different kind of wired-up on-board USB device it is,
>> to have the board definition file configure the driver for that
>> instantiation?
>
> Since it is USB, it is always discoverable, so it doesn't make any sense
> to have this type of thing.
>
> And since your only example was a network device, I think you proved
> your point :)

Well, thanks for the clear answer ^^

Have a nice weekend.

-Andy
