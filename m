Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343Ab1EAUMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 16:12:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56122 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab1EAUMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 16:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZXhTxEaPJzkMiPvn5KEPp+a+HE39juh1Eggk9/v/MtgxHDcujwX3t89Esh9rd06qD1
         szZ1yWauYcTOrDam9Vxn7U3FVWsyZtqYNxiKzINcDNyfH3FRdJbwPXGLaL5zsAJ589mQ
         3Q/lxND/n7FIMEEy0GdoxUIQp9zYnqEruCiT8=
Message-ID: <4DBDBD3D.9060005@lwfinger.net>
Date: Sun, 01 May 2011 15:06:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Shawn Nock <nock@nocko.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: rtlwifi: regression 39-rc5 (rtl8192ce)
References: <m3zkn6paj5.fsf@nocko.org>
In-Reply-To: <m3zkn6paj5.fsf@nocko.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2011 12:59 PM, Shawn Nock wrote:
>
> During heavy network traffic (esp. flash video) I see the attached NULL
> pointer dereference in 2.6.39-rc5 on an IBM Thinkpad x120e. Immediately
> afterward a "scheduling while atomic" bug is reported and the system
> becomes unresponsive. I am unable to produce this problem in 2.6.38.4.
>
> See attached backtrace and dmesg. Please let me know what I can collect
> to make this problem easier to troubleshoot.

Could you also supply the instruction byte sequence for the oops? It is the 
"Code:" line of the dump.

I think you are using a 32-bit system. Is that correct?

Is there one URL that exposes this problem? If so, please sent that as well.

Bisection is not likely to be of much help with this problem. Between 2.6.38 and 
2.6.39, driver rtl8192cu was added. It shares a lot of code with rtl8192ce, thus 
an extensive reorganization took place.

Larry

