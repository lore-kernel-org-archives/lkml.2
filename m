Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1BETkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:40:33 -0500
Received: from moh2-ve2.go2.pl ([193.17.41.200]:34401 "EHLO moh2-ve2.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab1BETkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:40:31 -0500
Message-ID: <4D4DA7AA.2030109@o2.pl>
Date: Sat, 05 Feb 2011 20:40:26 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101204 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Johan Hovold <jhovold@gmail.com>, Joe Perches <joe@perches.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [USB]Add Samsung SGH-I500/Android modem ID switch to visor driver
References: <4D4D9F37.4010201@o2.pl> <20110205192831.GA334@suse.de>
In-Reply-To: <20110205192831.GA334@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 66
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 05.02.2011 20:28, Greg KH pisze:
> Surely the configuration of the device looks different somehow?  If it
> reports itself as an ACM device, we should be able to detect that,
> right?
> 
> thanks,
> 
> greg k-h

I will try to look at it, but the modem likes to reset itself (and the bus)
when poked (for example when trying to read configuration strings).

Best regards,
Maciej Szmigiero
