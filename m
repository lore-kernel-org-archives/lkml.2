Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1E3JT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:19:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64190 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1E3JTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=m+FtP2gIWlKEMY1TYunP/LAP/FB9cfEUnc452r3u0K6Phs3W14+SeUxuPvEIs1rQ+D
         IjImgLnHY5yk5oyQoZxXltEu1Sibi/mzpk6cIKSD2B/Nu6DCw/PPmX5bgPhiizWSBIK/
         tWTi3U8xNZn1Q0EqSEQEs/dTkk/FOnflcNCbA=
Message-ID: <4DE36118.4050706@gmail.com>
Date: Mon, 30 May 2011 11:19:20 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
References: <4DE25252.7050503@gmail.com> <201105300754.14490.oneukum@suse.de>
In-Reply-To: <201105300754.14490.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 30/05/2011 07:54, Oliver Neukum ha scritto:
> Am Sonntag, 29. Mai 2011, 16:04:02 schrieb Riccardo Magliocchetti:
>
>> mtp-probe: bus: 6, device: 4 was not an MTP device
>> [20462.901834] cdc_acm 6-1:1.0: ttyACM0: USB ACM device
>> [20462.904417] usbcore: registered new interface driver cdc_acm
>> [20462.904420] cdc_acm: v0.26:USB Abstract Control Model driver for USB
>> modems and ISDN adapters
>> [20463.624142] usb 6-1: USB disconnect, device number 4
>> [20463.641859] CPU 0
>>
>> This is the stracktrace:
>>
>> acm_ctrl_msg+0x16/0x59
>> mutex_lock+0x13/0x2a
>> acm_port_down+0x4c/0xcb
>> acm_tty_close+0x75/0x93
>> tty_release+0x1b5/0x47c
>> ? compat_do_readv_write+0x199/0x1ae
>> fput+0xf8/0x1ad
>> filp_close+0x69/0x75
>> sys_close+0x8a/0xea
>> sysenter_dispatch+0x07/0x32
>
> So we are trying to talk to a device that is already gone.
> Is there anything unusual about your device? Could you
> post "lsusb -v"?

Yes, the unusual thing is that is very prone to freezing when booting, 
in fact it freezed when i got the crash in the laptop. Will post lsusb 
output later in the day.

thanks,
riccardo
