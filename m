Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1CKTNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:13:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63634 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1CKTNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rST3o0dW0ue/WLHF/9Wf1dnLQ/vJWjI+WsI2vdjIhTA0DTCJPJeJJb/hf9g+v9UWTp
         GxF1bgAP8JqjchTzFMM49UZDgWp/6k/2J+QbNzuVb2giEIS75H8TZAxTVzIog3vdFsco
         og5T6vPskfwB4zY4nSot54jNicYUuViYlm0JQ=
Message-ID: <4D7A72E3.1050407@gmail.com>
Date: Fri, 11 Mar 2011 21:07:15 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110225225055.GA5931@kroah.com> <4D787714.6060405@gmail.com> <20110310170143.GA24559@kroah.com> <AANLkTinyqJx76=nzepa9fe5VDzqiXRGCQ=E1SsKm2npE@mail.gmail.com> <20110310171940.GA24972@kroah.com> <4D790A20.3050105@gmail.com> <20110310180959.GA26927@kroah.com> <4D793D05.3070908@gmail.com> <20110310211519.GA11862@kroah.com> <4D79CB47.2030405@gmail.com> <20110311170313.GA10202@kroah.com>
In-Reply-To: <20110311170313.GA10202@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 07:03 PM, Greg KH wrote:
> Are you sure this was the driver you just built that I sent you?  Can
> you send the output of 'modinfo samsung-laptop'?
Yes, I'm pretty sure. Here is the modinfo output:

filename: 
/lib/modules/2.6.37+/kernel/drivers/staging/samsung-laptop/samsung-laptop.ko
license:        GPL
description:    Samsung Backlight driver
author:         Greg Kroah-Hartman <gregkh@suse.de>
alias:          dmi*:svn*SAMSUNGELECTRONICSCO.,LTD.*:pn*N130*:rn*N130*:
alias:          dmi*:svn*SAMSUNGELECTRONICSCO.,LTD.*:pn*N128*:rn*N128*:
depends:        rfkill
staging:        Y
vermagic:       2.6.37+ SMP mod_unload modversions 686
parm:           force:Disable the DMI check and forces the driver to be 
loaded (bool)
parm:           debug:Debug enabled or not (bool)

However, there seems to be some problem with aliases.

Thank you :)

Sincerely,
Nick
