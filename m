Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1CRWja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:39:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57373 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab1CRWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Hm5HCqAVPuobLBt6+l4LfJAKKv0LO3WKi9Kqt9RATZMvim4+SiKnTralI4t9eZABy+
         n547HgCtqIrtTMNnpOZ2pVq1UPPdntGuusIhbinsNvrtPhejLIuo99J6iu3RvZ7UuEdH
         jpbkrGeu/GQ71uLMnA3f6VnbLvE+HDFOk1L2A=
Message-ID: <4D83DF0D.5050006@linaro.org>
Date: Fri, 18 Mar 2011 22:39:09 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com>	 <20110317214042.GQ31411@opensource.wolfsonmicro.com>	 <20110317214736.GA29014@kroah.com> <201103172333.01474.arnd@arndb.de>	 <4D82979B.2050003@linaro.org> <1300487863.22236.1289.camel@pasglop>
In-Reply-To: <1300487863.22236.1289.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 10:37 PM, Somebody in the thread at some point said:
> On Thu, 2011-03-17 at 23:22 +0000, Andy Green wrote:
>>
>> Is there actually a need for sort of not platform_data but universal
>> vid_pid_specific_usb_device_option_data coming from the board
>> definition
>> file or bootloader for *pluggable* usb devices?  udev seems to be
>> well
>> established doing that already in a generic, not-platform-specific
>> way
>> that can go in all distros and so on nicely.  Maybe this is just my
>> impoverished imagination and people do want, say, some kinds of USB
>> mice
>> to operate at higher DPI or whatever when plugged in a specific board
>> because it is that board.
>
> Except that vid/pid are the -WRONG- way to do that. Your device is
> on-board, the proper way to identify it uniquely is it's topological
> location, ie path of HW port numbers.

Thanks Ben.

I'll go change that VID/PID stuff in my patches right away.

-Andy
