Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1BTKqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 05:46:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36932 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1BTKqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 05:46:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SPeolRSlEgOPFTl/c38mpaf7OkDE3yjeqcxidYeVk3sJvvtYazUCrq0g+7plz1PaOx
         /QaqTpNaPJPX45lYFSI3KcTlMZ4mauFRZeFbJd/Y/Yy6WZ75KTFD2MWtS6p3KHj9IBL1
         uV3wWt4WbPMY/Zp+mCg3HOsqYlEFxx6gEiVz4=
Message-ID: <4D60F108.9000106@gmail.com>
Date: Sun, 20 Feb 2011 11:46:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: stefanb@linux.vnet.ibm.com, linux-pm <linux-pm@lists.linux-foundation.org>,
        srajiv@linux.vnet.ibm.com, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <201102201144.34043.rjw@sisk.pl>
In-Reply-To: <201102201144.34043.rjw@sisk.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2011 11:44 AM, Rafael J. Wysocki wrote:
> On Sunday, February 20, 2011, Jiri Slaby wrote:
>> Hi,
>>
>> I'm unable to hibernate 2.6.37.1 unless I rmmod tpm_tis:
>> [10974.074587] Suspending console(s) (use no_console_suspend to debug)
>> [10974.103073] tpm_tis 00:0c: Operation Timed out
>> [10974.103089] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
>> [10974.103095] PM: Device 00:0c failed to freeze: error -62
>>
>> 2.6.37 worked fine. Going to revert 9b29050f8f7 (tpm_tis: Use timeouts
>> returned from TPM) for testing.
> 
> Yes, this has been confirmed to cause suspend regressions to happen

OK, the revert works for me too... Are there any fixes?

regards,
-- 
js
