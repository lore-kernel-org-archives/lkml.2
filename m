Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1BTLCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 06:02:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38910 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1BTLCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 06:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=d974ixZRk71f2K1fNwSSt/GTRdAEGz1GNZYk+bdBxuXOFBx/LlRQWaiWhifBPtd6QJ
         F4inTXPhprA6itwsVIurrE7DlyFCRXvmoeguR/GCiPHHwpWV0NukNExOMZbR2vgk0Mro
         Gqy1p7q+Gf4XlSYhITDvpHzPOiy/8tmbzn8s0=
Message-ID: <4D60F38C.5050704@gmail.com>
Date: Sun, 20 Feb 2011 11:57:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: stefanb@linux.vnet.ibm.com, linux-pm <linux-pm@lists.linux-foundation.org>,
        srajiv@linux.vnet.ibm.com, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net
Subject: [REVERT request stable-2.6.36/37] Re: 2.6.37.1 s2disk regression
 (TPM)
References: <4D60E93D.1050205@gmail.com> <201102201144.34043.rjw@sisk.pl> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl>
In-Reply-To: <201102201151.11635.rjw@sisk.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2011 11:51 AM, Rafael J. Wysocki wrote:
> On Sunday, February 20, 2011, Jiri Slaby wrote:
>> On 02/20/2011 11:44 AM, Rafael J. Wysocki wrote:
>>> On Sunday, February 20, 2011, Jiri Slaby wrote:
>>>> Hi,
>>>>
>>>> I'm unable to hibernate 2.6.37.1 unless I rmmod tpm_tis:
>>>> [10974.074587] Suspending console(s) (use no_console_suspend to debug)
>>>> [10974.103073] tpm_tis 00:0c: Operation Timed out
>>>> [10974.103089] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
>>>> [10974.103095] PM: Device 00:0c failed to freeze: error -62
>>>>
>>>> 2.6.37 worked fine. Going to revert 9b29050f8f7 (tpm_tis: Use timeouts
>>>> returned from TPM) for testing.
>>>
>>> Yes, this has been confirmed to cause suspend regressions to happen
>>
>> OK, the revert works for me too... Are there any fixes?
> 
> No, and the author and maintainer have not been responding.  If that contiunes,
> I'll simply ask Linus to revert it.

Ok then, stable team, please revert that from 2.6.37 stable.

I guess the same problem is in 2.6.36, so reverting it in 2.6.36 should
be done too...

thanks,
-- 
js
