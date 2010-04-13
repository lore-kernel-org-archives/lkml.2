Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab0DMH2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:28:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:39767 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0DMH2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d/OA3d+GfekWLiWeJfJKL+f5C/pO79RJtl/s0RDNBWY8l9veaImcia93oHGHtoG6Qu
         6ncTfhLAIV31XaHWCmHf3f0tG2qRE6tPAvfBSmGqxGGJp7UPLz8FWBW2101oClobATV5
         18MK2ER4c/ata8M4SE2W6sZReq5C0Mn2MtYgw=
MIME-Version: 1.0
In-Reply-To: <20100412191006.GJ3048@n2100.arm.linux.org.uk>
References: <20100303213329.GA500@alarsen.net>
	 <w2ocd73a99e1004061427t322f8d4cmecd708ad16580f00@mail.gmail.com>
	 <20100412191006.GJ3048@n2100.arm.linux.org.uk>
Date: Tue, 13 Apr 2010 09:22:32 +0200
Message-ID: <g2qcd73a99e1004130022ofa1da0br16ca99e96084e365@mail.gmail.com>
Subject: Re: [PATCH 1/2] AT91 slow-clock suspend: don't wait when turning PLLs 
	off
From: Andrew Victor <avictor.za@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Anders Larsen <al@alarsen.net>, linux-arm-kernel@lists.infradead.org,
       Julien Langer <julien.langer@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Russell,

>> > AT91: when turning off the PLLs during suspend, don't wait for the lock flag
>> > to be set. Previously the code would always run into the loop limitation
>> > of 1000 iterations because the flag is never set when turning the PLLs off.
>> >
>> > Signed-off-by: Julien Langer <julien.langer@gmail.com>
>> > Signed-off-by: Anders Larsen <al@alarsen.net>
>> > Cc: Andrew Victor <avictor.za@gmail.com>
>> > Cc: Russell King <linux@arm.linux.org.uk>
>>    Acked-by: Andrew Victor <linux@maxim.org.za>
>>
>>
> Thanks; I see your ack has been added to that patch.  Should I assume that
> this is for -rc rather than -devel?

If it can still be merged for -rc, that would be great.
Otherwise the -devel branch is ok.


Regards,
  Andrew Victor
