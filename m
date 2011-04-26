Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab1DZWaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:30:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36663 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496Ab1DZWai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FoMu1lt0Pg2aDLVBPmEzbSkRjEGqc6LT6q61Tm1+7F0rG1dRx1nhZusmpr2EwEPUza
         ajFW4Qt0Ycd1fgk910o2Lal0NJt2aXZUG/nBw7xJ9Wp9JSAFI8hOkrUdolBzENE0oZNC
         QsxCwTifyCZNchgoxNnU31vZ+qXnN6TKtSqf0=
Message-ID: <4DB74788.2000908@lwfinger.net>
Date: Tue, 26 Apr 2011 17:30:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com> <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan> <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I am trying a different driver now: rt2870sta
> I've read a few reports this may be the 'proper' one to use.
> So far so good, no lag or anything and I did not have to set power off
> either.

Driver rtl2870sta is not the proper one to use. In fact, a patch to delete 
rt2860sta and rt2870sta from the kernel was queued yesterday, and they will be 
gone by the time 2.6.40 is released.

New firmware for rt2800usb was just accepted into the linux-firmware git tree. 
Please obtain a copy and try it.

Larry
