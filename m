Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1ECBQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:16:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62589 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1ECBQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WwvMq8jsxWbbwM5kCPBbtJVMwppyktTN7F3JErxoX54qidNdACnrGU2mhKiWhXBms1
         TtYXjtoZdiAJfzAxEgWDOqJ6I0Te/TFsd5V+RnQjS4mC6oUzp1fkt8/XDMrfdOMCReYi
         ob/jdoHlVEWR7RAA/fXRoFq+dtgsmFkvLcYz0=
Message-ID: <4DBF574E.80309@lwfinger.net>
Date: Mon, 02 May 2011 20:15:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com> <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan> <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan> <4DB74788.2000908@lwfinger.net> <alpine.DEB.2.02.1104261923390.3894@p34.internal.lan> <alpine.DEB.2.02.1105021944560.14515@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1105021944560.14515@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 06:46 PM, Justin Piszcz wrote:
> Just an update, this driver has been solid so far:
> rt2870sta
>
> With the Media Link 150 USB stick, not a single crash yet--
> The rt2800usb driver is laggy and crashes the kernel (as of 2.6.38.x)--
> Is there a possiblity to get rtl2870sta into the mainline?

Not a chance. As of 2.6.39, it is gone.

> It is the best wireless driver I've used for Linux with various usb wifi
> adapters--

That driver was in staging because it does not use mac80211, which is an 
absolute requirement for a new mainline driver. Keeping things like rt2870sta 
that contain their own MAC layer just bloats the kernel and has code persist 
that no one really understands.

Please try the version of rt2800usb from compat-wireless with the latest 
firmware. If it still crashes the kernel, then post the bugs.

Larry
