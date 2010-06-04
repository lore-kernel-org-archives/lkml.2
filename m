Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0FDRwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:52:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51071 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0FDRwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=QD1pAqCFWVSDriisTT0lzE8574siFiG71+JL/34pd8FdJwf3TTjDzE1UoNkj8RsUdk
         9w562CJVIwoayC8p1PKKDjr4GbryGdzrFmbbqQRf99BLjFCjvcXzQNlEQXuQhLraWikf
         Z6PvJnjF3vxB7I4bdW11aTAK02X0rpdnFURgw=
MIME-Version: 1.0
In-Reply-To: <20100604152734.GB19468@elliptictech.com>
References: <Pine.LNX.4.64.1006041552280.2417@boston.corp.fedex.com>
	<20100604152734.GB19468@elliptictech.com>
Date: Sat, 5 Jun 2010 01:52:03 +0800
Message-ID: <AANLkTinvgAfeQfcT-am2O4WKHNwV7v9lyzgTftOmchGx@mail.gmail.com>
Subject: Re: Commit cfecde435dda78248d6fcdc424bed68d5db6be0b turns screen 
	blank
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>, Carl Worth <cworth@cworth.org>,
       Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 11:27 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 16:00 Fri 04 Jun     , Jeff Chua wrote:
>> The following commit causes screen to become blank. Upon boot up, screen
>> becomes blank (monitor can't sync to pc) with i915 compiled in the
>> kernel. With i915 as module, system boots up fine, but becomes blank as
>> soon as the module is loaded.
>>
>> Reverting it solves the problem. Problem only happens only Dell Optiplex
>> 780 with external LCD. But, works fine on Lenovo X201s internal LCD.
>
>> commit cfecde435dda78248d6fcdc424bed68d5db6be0b
>
> I imagine this is the same as the problem reported here:
>
>  http://lkml.org/lkml/2010/6/2/249
>

Nick,

That right. It's the same problem.

Thanks,
Jeff
