Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1BTKNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 05:13:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37514 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1BTKNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 05:13:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=daGXTmZGHEZM7tZZjK2bkhPxtHBqNoe4cmBCCBXUfnXOiHUD8litSAkCE9i+J4z8IM
         6RDPg0000FWldnPtMYEMAS+f1i27uGdXJOy6opSbORKCszm+wX2x9dhZ1SxE2NmBznCf
         2h/k3jsfDxlqy3taoF04uGWbLDEw48I45Ifls=
Message-ID: <4D60E93D.1050205@gmail.com>
Date: Sun, 20 Feb 2011 11:13:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: stefanb@linux.vnet.ibm.com
CC: linux-pm <linux-pm@lists.linux-foundation.org>, srajiv@linux.vnet.ibm.com,
        stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net
Subject: 2.6.37.1 s2disk regression (TPM)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm unable to hibernate 2.6.37.1 unless I rmmod tpm_tis:
[10974.074587] Suspending console(s) (use no_console_suspend to debug)
[10974.103073] tpm_tis 00:0c: Operation Timed out
[10974.103089] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
[10974.103095] PM: Device 00:0c failed to freeze: error -62

2.6.37 worked fine. Going to revert 9b29050f8f7 (tpm_tis: Use timeouts
returned from TPM) for testing.

regards,
-- 
js
