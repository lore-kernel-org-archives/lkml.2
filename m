Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0IKWxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 18:53:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50090 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0IKWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 18:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HTC7T4xjXUZ1V5p+pM5pHIGNL1Fsxs1YKfP8ec8+XXIlWqUlUCP02Oe0bGjDxeWKc7
         YLdMwgv6vtjamclxtvBFfhaHIFsCxR0Ef9rI8Zy+Hekb4l5gsUXGq2U5EPSlW6o034kG
         qafzUeCBv0J6ujk7jMw4NxQDePhQPSkoChsek=
Message-ID: <4C8C085E.4050200@gmail.com>
Date: Sat, 11 Sep 2010 16:53:18 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: matt.causey@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Is via-velocity broken in 2.6.34?
References: <AANLkTi=kbonQ11mLpkd4EnSr3ch8yDssnjaUsgw_tVw9@mail.gmail.com>	<20100908.083022.189687100.davem@davemloft.net>	<AANLkTimRPOD857-pFXUJPxBw0RYXYe8OiPFwisY28x5B@mail.gmail.com> <20100909.125710.226781968.davem@davemloft.net>
In-Reply-To: <20100909.125710.226781968.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2010 01:57 PM, David Miller wrote:
> From: Matt Causey<matt.causey@gmail.com>
> Date: Thu, 9 Sep 2010 10:42:21 -0700
>
>> So it wasn't immediately intuitive that we would need power
>> management enabled in order to use other parts of the system.
>
> ACPI is not power management.
>
> It's a set of infrastructure (including an interpreter and small
> firmware programs to drive specialized hardware) that allows the
> important details of your motherboard to be described accurately to
> the kernel by firmware authors.
>
> That's why it's called "Advanced Configuration and Power Interface"
> and not just "Advanced Power Interface" :-)
>
> It also provides more accurate tables to describe things like
> the cpus in your system etc., to replace deprecated mechanisms
> for that such as MPS.

I'd think we'd save some trouble if we forced ACPI to on unless EMBEDDED 
was set or something, to indicate you shouldn't turn it off unless you 
really know what you're doing..
