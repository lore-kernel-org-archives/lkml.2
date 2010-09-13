Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0IMRDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:03:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54753 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0IMRDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=n8LIaZqjry60et/a5vwTIy/w6W05jy5LIJih3BEoDTaLRaVRy4Cd8weMwxMK2Efv8U
         H6oMNWVeSjj0Vgy9pyJUOltOJSmyTTM0nVmkzSkC1ncOA7zJT4BdVpS/E4QpQh9wNkR+
         /yAvwtYndWrRac50+DMvGEzrkWh04D9iEGIz8=
Message-ID: <4C8E594B.6080100@suse.cz>
Date: Mon, 13 Sep 2010 19:03:07 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Phil Dibowitz <phil@ipom.com>, Greg KH <gregkh@suse.de>, stable@kernel.org,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device events
 loss
References: <Pine.LNX.4.44L0.1009131219490.1315-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009131219490.1315-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 06:24 PM, Alan Stern wrote:
> Jiri, as a workaround for people using the current 3.6.34.stable, you
> can ask them to do:
> 
> 	echo on >/sys/bus/usb/devices/.../power/level
> 
> with the "..." filled in appropriately.

Yeah, the people are using that already. (Actually, they attached a udev
script to do that automatically.) Or usbcore.autosuspend=-1 is an easier
workaround (but disables autosuspend completely, indeed).

thanks,
-- 
js
suse labs
