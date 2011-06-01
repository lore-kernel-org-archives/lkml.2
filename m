Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1FASEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:04:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54749 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1FASEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bYa96AnGreJdK/LQ5jMenK+A7MvG5TqeJGL4LrtbaJxe7hGOotf9ZlN8f8GyhF6TfI
         QzZJnWeyi0oleLLyFfSad0H5g8xtKsvoN0VP9Fxsco9ITt/U1xyLhuWUe6p5PksP7knA
         SAJfyBzNnbt3VCehYngg5UhZpRw9jJBdUs84M=
Message-ID: <4DE67F36.8060600@gmail.com>
Date: Wed, 01 Jun 2011 20:04:38 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
References: <4DE25252.7050503@gmail.com> <201105311037.46856.oneukum@suse.de> <4DE5E4C8.5060706@gmail.com> <201106010934.45691.oneukum@suse.de>
In-Reply-To: <201106010934.45691.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 01/06/2011 09:34, Oliver Neukum ha scritto:
> Am Mittwoch, 1. Juni 2011, 09:05:44 schrieb Riccardo Magliocchetti:
>>>> Here's the lsusb -v
>>>
>>> There is something strange going on. This is a cdc-ether device.
>>> Are you using any additional patches?
>>
>> I'm using a vanilla 2.6.39. I can get only lsusb when the phone is
>> booted and in that case it is recgnized as cdc-ether.
>>
>> This is what i got when i attached the phone switched off like when i
>> got the crash:
>
> Then please post lsusb -v of that state. This is a log of a connection
> going wrong due to a bad cable or interference. Does that always happen?

yes it does always happen because (i think) the device hangs, so lsusb 
does not show the device.

thanks,
riccardo
