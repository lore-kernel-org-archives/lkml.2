Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab0DLPzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:55:44 -0400
Received: from borg.asidev.net ([95.141.32.69]:37469 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0DLPzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:55:42 -0400
Message-ID: <4BC3427A.2030801@evidence.eu.com>
Date: Mon, 12 Apr 2010 17:55:38 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rick Bronson <rick@efn.org>,
       hskinnemoen@atmel.com, John Nicholls <john@thinlinx.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       Ryan Mallon <ryan@bluewatersys.com>, rmk@arm.linux.org.uk,
       linux@maxim.org.za,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
References: <20100412094328.GA18182@frolo.macqel>
In-Reply-To: <20100412094328.GA18182@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter ha scritto:
> On Wed, Feb 13, 2008 at 08:28:49AM +0000, Alan Cox wrote:
>   
>>> Thank you for the feedback.
>>>
>>> Let me know if this new version solves the above problems.
>>>       
>> Looks good to me. Thanks for the quick clean up.
>>     
>
> Could someone add somewhere (Documentation, or usr/include/linux/serial.h)
> a precise documentation of how this is to be used from user-space,
> and implemented in other drivers ?
>   

I can add a short Documention/ file containing information about how to
use ioctls with this driver.

I'll add the document when I'll submit the final patch.

Regards,

            Claudio

