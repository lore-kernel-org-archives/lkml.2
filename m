Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962Ab1EBOtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:49:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39557 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395Ab1EBOtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OcKFvIeBPHY8QSHFH+g9U0mGy2BegshYAefaEeOe63RflrFpC6+LqQ/7e4MQEd6GHG
         DXO/flPDLA2Ko2ZJOLD8WgixAvmNmzW/+3oKRNVP7SEvaTpYVRHdrQQ53gq6Qo/xbLJl
         OkixtoroLHPOEtMaylqhUuexDJBBLvqnojp1U=
Message-ID: <4DBEC462.2080805@lwfinger.net>
Date: Mon, 02 May 2011 09:49:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Shawn Nock <nock@nocko.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: rtlwifi: regression 39-rc5 (rtl8192ce)
References: <fa.edeGRjft5wqQRP07grcwfUVPlIA@ifi.uio.no>	<fa.0KaksBH9ogj3psmzYEvXzvHxClw@ifi.uio.no> <m3d3k1b2me.fsf@nocko.org>
In-Reply-To: <m3d3k1b2me.fsf@nocko.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 09:26 AM, Shawn Nock wrote:
> Larry Finger<Larry.Finger@lwfinger.net>  writes:
>
>> On 05/01/2011 12:59 PM, Shawn Nock wrote:
>>> During heavy network traffic (esp. flash video) I see the attached
>>> NULL pointer dereference in 2.6.39-rc5 on an IBM Thinkpad
>>> x120e. Immediately afterward a "scheduling while atomic" bug is
>>> reported and the system becomes unresponsive. I am unable to produce
>>> this problem in 2.6.38.4.
>>> See attached backtrace and dmesg. Please let me know what I can
>>> collect to make this problem easier to troubleshoot.
>>
>> Could you also supply the instruction byte sequence for the oops? It
>> is the "Code:" line of the dump.
>
> I had not been able to capture that, as the scheduler oops was triggered
> during the call stack dump (before the Code line).
>
>> I think you are using a 32-bit system. Is that correct?
>
> Correct.
>
>> Is there one URL that exposes this problem? If so, please sent that as
>> well.
>
> It had been speedtest.net (which *used* to crash this all the
> time). I've since re-configured the kernel to allow it to build faster
> (fedora .config trimmed to remove a lot of the unneeded modules). I can
> no longer trigger this BUG.
>
> I originally thought that this may be because I enabled the 8192CU
> driver, but clean kernel without it also doesn't trigger the bug. My new
> hypothesis is that building the kernel for the AMD processor type was a
> mistake (the only other significant change was that I went back to
> Pentium Pro as the CPU target).
>
> As far as I can tell this problem is resolved (20+ hours without issue,
> less than 20 min previously) and probably due to GCC not being aware of
> this (newish) AMD processor.
>
> Sorry for the false alarm and thanks,

No problem. Let me know if it resurfaces again.

Larry
